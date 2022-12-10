//
//  Persistence.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newAssign = Assignment(context: viewContext)
            newAssign.name = "Assignment"
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Homeworks")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}


extension PersistenceController {
    
    func save(context: NSManagedObjectContext){
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addAssign(name: String, duedate: Date, context: NSManagedObjectContext) {
        withAnimation {
            let newAssign = Assignment(context: context)
            newAssign.name = name
            newAssign.duedate = duedate
            save(context: context)
        }
    }
    func addAsses(name: String, testdate: Date, context: NSManagedObjectContext){
        let newAsses = Assessment(context: context)
        newAsses.name = name
        newAsses.date = testdate
        save(context: context)
    }
    func addURL(url: URL,name: String ,relateTo test: Assessment){
        if let context = test.managedObjectContext{
            context.performAndWait {
                let newurl = Refurl(context: context)
                newurl.assessment = test
                newurl.name = name
                newurl.url = url
                newurl.dateadded = Date.now
                save(context: context)
            }
        }
    }
    func deleteTest(assesment: Assessment, context: NSManagedObjectContext){
        context.delete(assesment)
        save(context: context)
    }
    func deleteAssign(assign: Assignment, context: NSManagedObjectContext){
        context.delete(assign)
        save(context: context)
    }
    func addCheckPoint(name: String, deadline: Date, relateTo assign: Assignment){
        if let context = assign.managedObjectContext{
            context.performAndWait {
                let newCheck = Checkpoint(context: context)
                newCheck.name = name
                newCheck.id = UUID()
                newCheck.deadline = deadline
                newCheck.assign = assign
                save(context: context)
            }
        }
    }
    func deleteCheckpoint(checkpoint: Checkpoint, context: NSManagedObjectContext){
        context.delete(checkpoint)
        save(context: context)
    }
    func editCheckpoint(checkpoint: Checkpoint,name: String,date: Date,  context: NSManagedObjectContext){
        checkpoint.name = name
        checkpoint.deadline = date
        save(context: context)
    }
    func addGroupChat(name: String, context: NSManagedObjectContext){
        let groupchat = GroupChat(context: context)
        groupchat.name = name
        save(context: context)
    }
    func addContact(name: String, phonenumber: String, image: Data, relateTo groupchat: GroupChat){
        if let context = groupchat.managedObjectContext{
            context.performAndWait {
                let newContact = Contact(context: context)
                newContact.name = name
                newContact.image = image
                newContact.phonenumber = phonenumber
                newContact.groupchat = groupchat
                save(context: context)
            }
        }
    }
    func deleteGroupChat(groupchat: GroupChat, context: NSManagedObjectContext){
        context.delete(groupchat)
        save(context: context)
    }
}
