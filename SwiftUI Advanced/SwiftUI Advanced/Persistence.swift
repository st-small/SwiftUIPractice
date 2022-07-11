//
//  Persistence.swift
//  SwiftUI Advanced
//
//  Created by Stanly Shiyanovskiy on 05.07.2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "SwiftUI_Advanced")
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("Store has been loaded \(storeDescription.url)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
