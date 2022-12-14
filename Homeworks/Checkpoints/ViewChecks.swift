//
//  ViewChecks.swift
//  Homeworks
//
//  Created by Nate on 11/26/22.
//

import SwiftUI

struct ViewChecks: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var assign: Assignment
    init(assign: Assignment) {
        self.assign = assign
        let nsFetchRequest = Checkpoint.fetchRequest()
        nsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Checkpoint.deadline, ascending: true)]
        nsFetchRequest.predicate = NSPredicate(format: "assign = %@", assign)
        fetchRequest = FetchRequest(fetchRequest: nsFetchRequest, animation: .default)
    }
    private let fetchRequest: FetchRequest<Checkpoint>
    private var checkpoints: FetchedResults<Checkpoint> {
        return fetchRequest.wrappedValue
    }
    @State var name = ""
    @State var date = Date()
    @State var editingcheck = UUID()
    @State var editmode = false
    var body: some View {
            NavigationView{
                List{
                    ForEach(checkpoints) { checkpoint in
                        if checkpoint.id == editingcheck && editmode{
                            editView(checkpoint: checkpoint)
                        }else{
                            HStack{
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                Text(checkpoint.name ?? "")
                                Spacer()
                                Text(checkpoint.deadline ?? .now, style: .timer)
                            }.font(.title.bold())
                            .contextMenu{
                                Button {
                                    editmode.toggle()
                                    editingcheck = checkpoint.id ?? .init()
                                } label: {
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                                Button(role: .destructive) {
                                    AssignController().deleteCheckpoint(checkpoint: checkpoint, context: viewContext)
                                } label: {
                                    Text("Delete")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        if editmode{
                            Button {
                                editmode = false
                            } label: {
                                Text("Done")
                            }.buttonStyle(.bordered)
                                .cornerRadius(.infinity)
                        }
                    }
                    ToolbarItem(placement: .cancellationAction) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Leave")
                        }.buttonStyle(.bordered)
                            .cornerRadius(.infinity)
                    }
                }
            }
    }
}

extension ViewChecks{
    @ViewBuilder
    func editView(checkpoint: Checkpoint) -> some View{
        HStack{
            TextField("", text: $name, axis: .vertical)
                .labelsHidden()
                .textFieldStyle(.roundedBorder)
            Spacer()
            DatePicker("", selection: $date)
                .labelsHidden()
                .datePickerStyle(.compact)
        }.font(.title3.bold())
            .padding()
            .onAppear(){
                name = checkpoint.name ?? ""
                date = checkpoint.deadline ?? .now
            }
            .onChange(of: name) { newValue in
                AssignController().editCheckpoint(checkpoint: checkpoint, name: name, date: date, context: viewContext)
            }
            .onChange(of: date) { newValue in
                AssignController().editCheckpoint(checkpoint: checkpoint, name: name, date: date, context: viewContext)
            }
    }
}
