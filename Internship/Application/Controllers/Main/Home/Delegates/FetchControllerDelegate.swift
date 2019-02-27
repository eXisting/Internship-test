//
//  FetchControllerDelegate.swift
//  Internship
//
//  Created by sys-246 on 2/22/19.
//  Copyright © 2019 Andrey Popazov. All rights reserved.
//

import UIKit
import CoreData

extension HomeViewController: NSFetchedResultsControllerDelegate {
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
    print("tableView.beginUpdates()")
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    print("Header method")
//    switch type {
//    case .insert:
//      tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
//    case .delete:
//      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
//    case .move:
//      break
//    case .update:
//      break
//    }
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    print("Row method for \(indexPath) with new \(newIndexPath)")
//    switch type {
//    case .insert:
//      tableView.insertRows(at: [newIndexPath!], with: .fade)
//    case .delete:
//      tableView.deleteRows(at: [indexPath!], with: .fade)
//    case .update:
//      tableView.reloadRows(at: [indexPath!], with: .fade)
//    case .move:
//      tableView.moveRow(at: indexPath!, to: newIndexPath!)
//    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
    print("tableView.endUpdates()")
  }
}
