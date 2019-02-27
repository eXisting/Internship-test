//
//  CoreDataStack.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager: NSObject {

  let modelName = "DepartmentsBook"
  
  let employeeEntity = "Employee"
  let departmentEntity = "Department"
  let roleEntity = "Role"

  // MARK: Fields
  
  static let shared = DataBaseManager()
  
  private var persistentStoreCoordinator: NSPersistentStoreCoordinator?
  
  private var mainManagedObjectContext: NSManagedObjectContext?
  private var storeManagedObjectContext: NSManagedObjectContext?
  
  lazy var resultController: NSFetchedResultsController<Department> = {
    let fetchRequest: NSFetchRequest<Department> = Department.fetchRequest()
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
//    fetchRequest.relationshipKeyPathsForPrefetching = ["department"]
    fetchRequest.fetchBatchSize = 20
    
    let controller = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: mainManagedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      let _ = try controller.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return controller
  }()
  
  // MARK: Initialization

  private override init() {
    super.init()
    setupPersistentStore()
    setupContext()
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private func setupPersistentStore() {
    var storeUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
    storeUrl.appendPathComponent("DepartmentBook.sqlite")
    
    let modelUrl = Bundle.main.url(forResource: "DepartmentBook", withExtension: "momd")
    
    let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl!)
    
    persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel!)
    
    let options = [NSMigratePersistentStoresAutomaticallyOption: true,
                  NSInferMappingModelAutomaticallyOption: true]
    
    do {
      let _ = try persistentStoreCoordinator!.addPersistentStore(
        ofType: "SQLite",
        configurationName: nil,
        at: storeUrl,
        options: options)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  private func setupContext() {
    mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    mainManagedObjectContext!.undoManager = nil
    mainManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    mainManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    storeManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    storeManagedObjectContext!.undoManager = nil
    storeManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    storeManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    // Observer for merging changes between different threads - core for NSFetchControllerDelegate
    NotificationCenter.default.addObserver(self, selector: #selector(backgroundContextDidChanges), name: .NSManagedObjectContextDidSave, object: storeManagedObjectContext)
  }
  
  @objc func backgroundContextDidChanges(notification: Notification) {
    self.mainManagedObjectContext?.mergeChanges(fromContextDidSave: notification as Notification)
  }
  
  // MARK: Fetch requests
  
  func getManagers() ->  [Employee] {
    let fetchRequest = NSFetchRequest<Employee>()
    
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: employeeEntity, in: mainManagedObjectContext!)
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.predicate = NSPredicate(format: "role.name contains[c] %@", RoleType.manager.rawValue)
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    return self.performFetch(on: mainManagedObjectContext, fetch: fetchRequest as! NSFetchRequest<NSManagedObject>) as! [Employee]
  }
  
  func getRoles() -> [Role] {
    let fetchRequest = NSFetchRequest<Role>()
    
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: roleEntity, in: mainManagedObjectContext!)    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    return self.performFetch(on: mainManagedObjectContext, fetch: fetchRequest as! NSFetchRequest<NSManagedObject>) as! [Role]
  }
  
  // MARK: Actions
  
  func update(with dict: [String: Any]) {
    let employee = storeManagedObjectContext!.object(with: dict["objectId"] as! NSManagedObjectID) as! Employee
    
    setFields(of: employee, with: dict)
    
    guard let departmentIds = dict["departmentsIds"] as? [NSManagedObjectID],
      let roleId = dict["roleId"] as? NSManagedObjectID else {
        print("Cannot parse dict in update core data")
        return
    }
    
    var newDepartments: Set<Department> = []
    for id in departmentIds {
      let department = storeManagedObjectContext?.object(with: id) as! Department
      newDepartments.insert(department)
      department.addToEmployee(employee)
    }
    
    employee.department?.addingObjects(from: newDepartments)
    
    buildLocation(attachedTo: employee, from: dict)
    
    let role = storeManagedObjectContext?.object(with: roleId) as! Role
    
    employee.role?.addToEmployee(employee)
    role.addToEmployee(employee)
    
    save(context: storeManagedObjectContext)
  }
  
  func delete(employeeId: NSManagedObjectID, fromDepartment departmentId: NSManagedObjectID) {
    let department = storeManagedObjectContext?.object(with: departmentId) as! Department
    let employee = storeManagedObjectContext?.object(with: employeeId) as! Employee
    
    department.removeFromEmployee(employee)
//    employee.removeFromDepartment(department)
    
    if department.name == RoleType.manager.rawValue {
      storeManagedObjectContext!.delete(employee)
    }
    
    save(context: storeManagedObjectContext)
  }
  
  func delete(departmentId: NSManagedObjectID) {
    let department = storeManagedObjectContext?.object(with: departmentId) as! Department
    
    if let departmentEmployees = department.employee {
      for employee in departmentEmployees {
        let storedEmployee = employee as! Employee

        department.removeFromEmployee(storedEmployee)
        storedEmployee.removeFromDepartment(department)

        if storedEmployee.department?.count == 0 {
          storeManagedObjectContext!.delete(storedEmployee)
        }
      }
    }
    
    storeManagedObjectContext!.delete(department)
    
    save(context: storeManagedObjectContext)
  }
  
  // MARK: Create
  
  func createEmployee(from dict: [String: Any]) {
    let employee = NSEntityDescription.insertNewObject(forEntityName: employeeEntity, into: storeManagedObjectContext!) as! Employee
    
    setFields(of: employee, with: dict)
    
    if let departmentsIds = dict["departmentsIds"] as? [NSManagedObjectID] {
      for id in departmentsIds {
        let department = storeManagedObjectContext!.object(with: id) as! Department
        department.addToEmployee(employee)
        employee.addToDepartment(department)
      }
    }
    
    buildLocation(attachedTo: employee, from: dict)
    
    let roleId = dict["roleId"] as! NSManagedObjectID
    let role = storeManagedObjectContext?.object(with: roleId) as! Role
    role.addToEmployee(employee)
    
    save(context: storeManagedObjectContext)
  }
  
  func createDepartment(from dict: [String: Any]) {
    let department = NSEntityDescription.insertNewObject(forEntityName: departmentEntity, into: storeManagedObjectContext!) as! Department
    
    department.setValue(dict["name"], forKey: "name")
    
    if let employeesIds = dict["employeesIds"] as? [NSManagedObjectID] {
      for id in employeesIds {
        let employee = storeManagedObjectContext!.object(with: id) as! Employee
        department.addToEmployee(employee)
        employee.addToDepartment(department)
      }
    }
    
    save(context: storeManagedObjectContext)
  }
  
  func createRole(_ name: String) {
    let object = NSEntityDescription.insertNewObject(forEntityName: roleEntity, into: storeManagedObjectContext!)
    
    object.setValue(name, forKey: "name")
    
    save(context: storeManagedObjectContext)
  }
  
  // MARK: Helpers
  
  private func performFetch(on context: NSManagedObjectContext?, fetch: NSFetchRequest<NSManagedObject>) -> [NSManagedObject] {
    do {
      guard let result = try context?.fetch(fetch) else {
        return []
      }
      return result
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return []
  }
  
  private func save(context: NSManagedObjectContext?) {
    saveDatabase(with: context)
  }
  
  private func saveDatabase(with context: NSManagedObjectContext?) {
    if persistentStoreCoordinator == nil {
      return
    }
    
    let strongContext = context
    strongContext?.performAndWait {
      do {
        try strongContext?.save()
      } catch {
        print(error.localizedDescription)
      }
      
      let parentContext = strongContext?.parent
      parentContext?.performAndWait {
        saveDatabase(with: parentContext)
      }
    }
  }
  
  private func setFields(of object: NSManagedObject, with dict: [String: Any]) {
    object.setValue(dict["name"], forKey: "name")
    object.setValue(dict["phone"], forKey: "phone")
    object.setValue(dict["email"], forKey: "email")
    object.setValue(dict["photo"], forKey: "photo")
  }
  
  private func buildLocation(attachedTo employee: Employee, from dict: [String: Any]) {
    if employee.location == nil {
      employee.location = Location(context: storeManagedObjectContext!)
    }
    
    let dataLocation = dict["location"] as! [String: Any]
    employee.location!.name = (dataLocation["name"] as! String)
    employee.location!.longitude = (dataLocation["longitude"] as! Double)
    employee.location!.latitude = (dataLocation["latitude"] as! Double)
  }
}
