//
//  ListView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.name, ascending: true)],
        animation: .default)
    private var assignments: FetchedResults<Assignment>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assessment.date, ascending: true)],
        animation: .default)
    private var tests: FetchedResults<Assessment>
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var addtest: Bool
    @Binding var addnew: Bool
    @Binding var duedate: Date
    @Binding var datepicker: Bool
    @Binding var editing: Bool
    var body: some View {
        VStack{
        if addtest{
            NewTestItem(addtest: $addtest, duedate: $duedate, editing: $editing, datepicker: $datepicker)
        }
        ForEach(tests){test in
            TestView(assesment: test)
                .contextMenu{
                    Button(role: .destructive) {
                        PersistenceController().deleteTest(assesment: test, context: viewContext)
                    } label: {
                        Text("Delete")
                        Image(systemName: "trash")
                    }
                    
                }
        }
        LazyVGrid(columns: columns, spacing: 10){
                if addnew {
                    NewAssignItem(addnew: $addnew, duedate: $duedate, editing: $editing, datepicker: $datepicker)
                }
            ForEach(assignments){assign in
                AssignItem(assign: assign)
                    .contextMenu{
                        Button(role: .destructive) {
                            PersistenceController().deleteAssign(assign: assign, context: viewContext)
                        } label: {
                            Text("Delete")
                            Image(systemName: "trash")
                        }
                        
                    }
            }
        }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
