//
//  CoreDataStack.swift
//  inern
//
//  Created by Andrey Popazov on 2/11/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import Foundation
import CoreData

class DataBaseManager {

  let modelName = "DepartmentsBook"
  
  static let shared = DataBaseManager()
  
  private var persistantStoreCoordinator: NSPersistentStoreCoordinator?
  private var mainManagedObjectContext: NSManagedObjectContext?
  private var storeManagedObjectContext: NSManagedObjectContext?
  
  var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
  
  private init() {
    setupContext()
    setupPersistentStore()
  }
  
  private func setupContext() {
    
  }
  
  private func setupPersistentStore() {
    
  }
  
  private func createObject() {
    
  }
  
  private func updateObject() {
    
  }
  
  private func deleteObject() {
    
  }
}
