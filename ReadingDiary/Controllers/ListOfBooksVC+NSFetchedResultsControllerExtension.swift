//
//  ListOfBooksVC+NSFetchedResultsControllerExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 25.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import CoreData

extension ListOfBooksVC: NSFetchedResultsControllerDelegate {
    
    //  MARK: Setup fetchedResultController
    func setupFetchedResultController() {
        
        //  create fetchRequest
        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")
        fetchRequest.sortDescriptors = []
        
        //  create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        //  start the fetch
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("The fetch couldn't be performed : \(error.localizedDescription)")
        }
    }
    
    //    MARK: fetchRequest with predicate for searching
    func performSearch(textForSearching: String) {
        // create fetchRequest
        let fetchRequest = NSFetchRequest<Book>(entityName: "Book")
        
        fetchRequest.predicate = NSCompoundPredicate(type:.or, subpredicates:
            [
                NSPredicate(format: "title CONTAINS[cd] %@",textForSearching ),
                NSPredicate(format: "author CONTAINS[cd] %@",textForSearching )
        ])
        
        fetchRequest.sortDescriptors = []
        
        // create the FetchedResultsController
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: PersistenceService.context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        // start the fetch
        do {
            try fetchedResultsController.performFetch()
        } catch  {
            fatalError("The fetch couldn't be performed : \(error.localizedDescription)")
        }
    }
    
    //  MARK: Setup controllers functions that trak content changing
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: tableView.insertSections(indexSet, with: .fade)
        case .delete: tableView.deleteSections(indexSet, with: .fade)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}


