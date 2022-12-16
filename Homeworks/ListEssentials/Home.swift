//
//  ContentView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.name, ascending: true)],
        animation: .default)
    private var assignments: FetchedResults<Assignment>
    @Binding var addtest: Bool
    @Binding var addnew: Bool
    @Binding var datepicker: Bool
    @Binding var duedate: Date
    @Binding var editing: Bool
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text("Assignments: \(assignments.count)")
                            .font(.title2.bold())
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Spacer()
                        MenuButtons()
                    }.padding(.horizontal)
                        .padding(.top, 50)
                    ListView(addtest: $addtest, addnew: $addnew, duedate: $duedate, datepicker: $datepicker, editing: $editing)
                        .padding()
                }
            }.overlay {
                ZStack{
                    //If user wanted to edit the date of the assignmnet
                    if datepicker{
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .ignoresSafeArea()
                        DatePicker("Due Date", selection: $duedate, in: Date.now...)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                            .padding()
                            .background(colorScheme == .dark ? .black:.white,in: RoundedRectangle (cornerRadius: 12, style: .continuous))
                            .padding()
                    }
                }
            }
        }
    }
}



extension Home {
    @ViewBuilder
    func MenuButtons() -> some View {
        Menu {
            Button {
                withAnimation {
                    addnew.toggle()
                }
            } label: {
                Text("Assignment")
                Image(systemName: "list.bullet.rectangle.portrait")
            }
            Button {
                addtest.toggle()
            } label: {
                Text("Test/Quiz")
                Image(systemName: "list.bullet.clipboard.fill")
            }
        } label: {
            Image(systemName: "plus")
                .font(.title2.bold())
        }.disabled(addtest || addnew)
            .buttonStyle(.borderedProminent)
    }
}


extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
