//
//  ContentView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.name, ascending: true)],
        animation: .default)
    private var assignments: FetchedResults<Assignment>
    @State var addnew = false
    @State var datepicker = false
    @State var duedate = Date.now
    @State var editing = false
    var body: some View {
        NavigationStack {
            ScrollView{
                VStack(alignment: .leading, spacing: 10){
                    HStack{
                        Text("Assignments: \(assignments.count)")
                            .font(.title2.bold())
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                        Spacer()
                        Button {
                            withAnimation{
                                addnew.toggle()
                            }
                        } label: {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                        }.buttonStyle(.bordered)
                        
                    }.padding(.horizontal)
                    ListView(addnew: $addnew, duedate: $duedate, datepicker: $datepicker, editing: $editing)
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        if editing{
                            DoneButton(date: false)
                        }
                    }
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
                            .background(.white,in: RoundedRectangle (cornerRadius: 12, style: .continuous))
                            .padding()
                            .toolbar {
                                ToolbarItem(placement: .confirmationAction) {
                                    DoneButton(date: true)
                                }
                            }
                    }
                }
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}



extension Home {
    @ViewBuilder
    //Done button to finish textfield or datepicker
    func DoneButton(date: Bool) -> some View{
                Button {
                    withAnimation {
                        if date{
                            datepicker = false
                        }else{
                            editing = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                } label: {
                    Text("Done")
                        .bold()
                        .foregroundColor(.black)
                }.buttonStyle(.bordered)
                    .cornerRadius(.infinity)
    }
}
