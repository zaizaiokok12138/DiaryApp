//
//  CoreDataStack.swift
//  DiaryApp
//
//  Created by Michele Mola on 15/09/2018.
//  Copyright © 2018 Michele Mola. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
  
  static let sharedInstance = CoreDataStack()
  
  lazy var managedObjectContext: NSManagedObjectContext = {
    let container = self.persistentContainer
    return container.viewContext
  }()
  
  private lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "DiaryApp")
    container.loadPersistentStores() { storeDescription, error in
      if let error = error as NSError? {
        fatalError("Unresolved error: \(error), \(error.userInfo)")
      }
      
    }
    
    return container
  }()
    
}

extension NSManagedObjectContext {
  func saveChanges() {
    if self.hasChanges {
      do {
        try save()
      } catch {
        fatalError("Error: \(error.localizedDescription)")
      }
    }
  }
}
