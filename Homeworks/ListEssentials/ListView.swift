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
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var addnew: Bool
    @Binding var duedate: Date
    @Binding var datepicker: Bool
    @Binding var editing: Bool
    var body: some View {
        LazyVGrid(columns: columns){
            if addnew {
                NewListItem(addnew: $addnew, duedate: $duedate, editing: $editing, datepicker: $datepicker)
            }
            ForEach(assignments){assign in
                ListItem(assign: assign)
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

struct ListItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var checkpointadd = false
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
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Menu{
                        Button {
                            checkpointadd.toggle()
                        } label: {
                            Text("Add Checkpoint")
                            Image(systemName: "mappin.circle")
                        }
                }label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                }
                .padding(8)
            }
            Text("\(assign.name ?? "")")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
            ForEach(checkpoints.prefix(1)){checkpoint in
                CheckpointView(checkpoint: checkpoint)
            }
            if checkpoints.isEmpty{
                HStack{
                    Text("No Checkpoints")
                        .foregroundColor(.white)
                    Image(systemName: "checkmark")
                        .foregroundColor(.green)
                }.padding(.pi)
                    .bold()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .circular)
                        .foregroundColor(Color(.systemGray3))
                }
            }
            Spacer()
            HStack{
                Spacer()
                Text("Due Today!")
                    .bold()
                Spacer()
            }.padding(10)
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.ultraThinMaterial)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
        }.frame(width: 200, height: 200)
            .background(in: RoundedRectangle(cornerRadius: 5))
            .backgroundStyle(.blue.gradient)
            .fullScreenCover(isPresented: $checkpointadd) {
                CheckPointAdd(assign: assign)
            }
    }

    }

extension ListItem{
    @ViewBuilder
    func CheckpointView(checkpoint: Checkpoint) -> some View {
        VStack{
                Text(checkpoint.name ?? "")
                .padding(.pi)
            if checkpoint.deadline ?? .now < Date.now{
                Button {
                    PersistenceController().deleteCheckpoint(checkpoint: checkpoint, context: viewContext)
                } label: {
                    Image(systemName: "checkmark")
                }.padding(.pi)
                .background{Circle().foregroundColor(.green)}

            }else{
                Text(checkpoint.deadline ?? .now, style: .timer)
                    .padding(.horizontal)
                    .background{Capsule().foregroundColor(.red)}
            }
        }.font(.headline).bold()
            .foregroundColor(.white)
    }
}
