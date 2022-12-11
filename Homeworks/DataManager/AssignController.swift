//
//  AssignController.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI
import CoreData

struct AssignController {
    
    func addAssign(name: String, duedate: Date, context: NSManagedObjectContext) {
        withAnimation {
            let newAssign = Assignment(context: context)
            newAssign.name = name
            newAssign.duedate = duedate
            PersistenceController().save(context: context)
        }
    }
    
    func addCheckPoint(name: String, deadline: Date, relateTo assign: Assignment){
        if let context = assign.managedObjectContext{
            context.performAndWait {
                let newCheck = Checkpoint(context: context)
                newCheck.name = name
                newCheck.id = UUID()
                newCheck.deadline = deadline
                newCheck.assign = assign
                PersistenceController().save(context: context)
            }
        }
    }
    
    func deleteCheckpoint(checkpoint: Checkpoint, context: NSManagedObjectContext){
        context.delete(checkpoint)
        PersistenceController().save(context: context)
    }
    
    func deleteAssign(assign: Assignment, context: NSManagedObjectContext){
        context.delete(assign)
        PersistenceController().save(context: context)
    }
    
    
    func editCheckpoint(checkpoint: Checkpoint,name: String,date: Date,  context: NSManagedObjectContext){
        checkpoint.name = name
        checkpoint.deadline = date
        PersistenceController().save(context: context)
    }
}
