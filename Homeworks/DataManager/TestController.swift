//
//  TestController.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI
import CoreData

struct AssesController {
    func addAsses(name: String, testdate: Date, context: NSManagedObjectContext){
        let newAsses = Assessment(context: context)
        newAsses.name = name
        newAsses.date = testdate
        PersistenceController().save(context: context)
    }
    func addURL(url: URL,name: String ,relateTo test: Assessment){
        if let context = test.managedObjectContext{
            context.performAndWait {
                let newurl = Refurl(context: context)
                newurl.assessment = test
                newurl.name = name
                newurl.url = url
                newurl.dateadded = Date.now
                PersistenceController().save(context: context)
            }
        }
    }
    func deleteTest(assesment: Assessment, context: NSManagedObjectContext){
        context.delete(assesment)
        PersistenceController().save(context: context)
    }
}
