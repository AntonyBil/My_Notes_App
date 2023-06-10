//
//  CoreDataManager.swift
//  My_Notes
//
//  Created by apple on 10.06.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shered = CoreDataManager(modelName: "MyNotes")
    
    let peresistantContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return peresistantContainer.viewContext
    }
    
    init(modelName: String) {
        peresistantContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        peresistantContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error ocurred while saving: \(error.localizedDescription)")
            }
        }
    }
}

//MARK: - Helper functions

extension CoreDataManager {
    func createNote() -> Note {
        let note = Note(context: viewContext)
        note.id = UUID()
        note.text = ""
        note.lastUpdated = Date()
        save()
        return note
    }
}
