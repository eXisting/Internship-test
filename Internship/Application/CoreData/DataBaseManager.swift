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
  
  private(set) var mainManagedObjectContext: NSManagedObjectContext?
  private var storeManagedObjectContext: NSManagedObjectContext?
  
  private var employeesResultsController: NSFetchedResultsController<Employee>?
  private var rolesResultsController: NSFetchedResultsController<Role>?
  private var departmentsResultsController: NSFetchedResultsController<Department>?

  // MARK: Initialization

  private override init() {
    super.init()
    setupContext()
    setupPersistentStore()
  }
  
  private func setupContext() {
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
  
  private func setupPersistentStore() {
    mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    mainManagedObjectContext!.undoManager = nil
    mainManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    mainManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
    
    storeManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    storeManagedObjectContext!.undoManager = nil
    storeManagedObjectContext!.mergePolicy = NSOverwriteMergePolicy
    storeManagedObjectContext!.persistentStoreCoordinator = self.persistentStoreCoordinator
  }
  
  // MARK: Fetch result controllers
  
  func employeesFetchController() ->  NSFetchedResultsController<Employee> {
    if let controller = employeesResultsController {
      return controller
    }
    
    let fetchRequest = NSFetchRequest<Employee>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: employeeEntity, in: mainManagedObjectContext!)
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    employeesResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: mainManagedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      let _ = try employeesResultsController?.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return employeesResultsController!
  }
  
  func rolesFetchController() -> NSFetchedResultsController<Role> {
    if let controller = rolesResultsController {
      return controller
    }
    
    let fetchRequest = NSFetchRequest<Role>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: roleEntity, in: mainManagedObjectContext!)
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    rolesResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: mainManagedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
    
    do {
      let _ = try rolesResultsController!.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return rolesResultsController!
  }
  
  func departmentsFetchController() -> NSFetchedResultsController<Department> {
    if let controller = departmentsResultsController {
      return controller
    }
    
    let fetchRequest = NSFetchRequest<Department>()
    fetchRequest.entity = NSEntityDescription.entity(forEntityName: departmentEntity, in: mainManagedObjectContext!)
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
    fetchRequest.returnsObjectsAsFaults = false
    fetchRequest.fetchBatchSize = 20
    
    departmentsResultsController = NSFetchedResultsController(
      fetchRequest: fetchRequest,
      managedObjectContext: mainManagedObjectContext!,
      sectionNameKeyPath: nil,
      cacheName: nil)
        
    do {
      let _ = try departmentsResultsController!.performFetch()
    } catch {
      print("Unexpected error: \(error.localizedDescription)")
      abort()
    }
    
    return departmentsResultsController!
  }
  
  // MARK: Actions
  
  func update(with dict: [String: Any]) {
    let employee = storeManagedObjectContext!.object(with: dict["objectId"] as! NSManagedObjectID) as! Employee
    
    setFields(of: employee, with: dict)
    
//    let departmentId = dict["departmentsIds"] as! Set<NSManagedObjectID>
//
//    if employee.department != nil {
//      employee.removeFromDepartment(employee.department!)
//    }
//
//    // TODO: Add to departments
    
    let roleId = dict["roleId"] as! NSManagedObjectID
    let role = storeManagedObjectContext?.object(with: roleId) as! Role
    
    employee.role?.removeFromEmployee(employee)
    role.addToEmployee(employee)
    
    save(context: storeManagedObjectContext)
  }
  
  func delete(id: NSManagedObjectID) {
    storeManagedObjectContext!.delete(storeManagedObjectContext!.object(with: id))
    save(context: storeManagedObjectContext)
  }
  
  // MARK: Create
  
  func createEmployee(from dict: [String: Any]) {
    let employee = NSEntityDescription.insertNewObject(forEntityName: employeeEntity, into: storeManagedObjectContext!) as! Employee
    
    setFields(of: employee, with: dict)
    
//    let department = dict["department"] as! Department
//    employee.addToDepartment(department)
//    department.addToEmployee(employee)
    
    let roleId = dict["roleId"] as! NSManagedObjectID
    let role = storeManagedObjectContext?.object(with: roleId) as! Role
    role.addToEmployee(employee)
    
    save(context: storeManagedObjectContext)
  }
  
  func createDepartment(from dict: [String: Any]) {
    let department = NSEntityDescription.insertNewObject(forEntityName: departmentEntity, into: storeManagedObjectContext!) as! Department
//    let employee = storeManagedObjectContext!.object(with: dict["employeeId"] as! NSManagedObjectID) as! Employee
    
    department.setValue(dict["name"], forKey: "name")    
//    department.addToEmployee(employee)
//    employee.addToDepartment(department)
    
    save(context: storeManagedObjectContext)
  }
  
  func createRole(_ name: String) {
    let object = NSEntityDescription.insertNewObject(forEntityName: roleEntity, into: storeManagedObjectContext!)
    
    object.setValue(name, forKey: "name")
    
    save(context: storeManagedObjectContext)
  }
  
  // MARK: Helpers
  
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
}
