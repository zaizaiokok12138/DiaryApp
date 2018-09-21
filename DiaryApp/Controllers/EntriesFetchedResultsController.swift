//
//  EntriesFetchedResultsController.swift
//  DiaryApp
//
//  Created by Michele Mola on 08/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import CoreData

class EntriesFetchedResultsController: NSFetchedResultsController<Entry> {
  init(request: NSFetchRequest<Entry>, context: NSManagedObjectContext) {
    super.init(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    
    fetch()
    }
   

    
  func fetch() {
    do {
      try performFetch()
    } catch {
      fatalError()
    }
  }
}
