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
            Text("\(assign.name ?? "")")
                .bold()
                .font(.title2)
                .foregroundColor(.white)
                .padding(.top, 20)
            
            Button {
                checkpointadd.toggle()
            } label: {
                HStack{
                    Text("Checkpoints")
                    Image(systemName: "plus")
                }.bold()
                    .padding(.pi)
                    .foregroundColor(.white)
            }.background{RoundedRectangle(cornerRadius: 25, style: .continuous).foregroundColor(.red)}
                .shadow(radius: 4)
                .fullScreenCover(isPresented: $checkpointadd) {
                    CheckPointAdd(assign: assign)
                }
                .padding(.pi)
            ForEach(checkpoints.prefix(1)){checkpoint in
                VStack{
                        Text(checkpoint.name ?? "")
                    Text(checkpoint.deadline ?? .now, style: .timer)
                        .padding(.horizontal)
                        .background{Capsule().foregroundColor(.red)}
                }.font(.headline).bold()
                    .foregroundColor(.white)
            }
            Spacer()
            HStack{
                Spacer()
                Text("Due Today!")
                    .bold()
                Spacer()
            }.padding(10)
                .background{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                }
            .padding()
        }.frame(width: 200, height: 200)
            .background(in: RoundedRectangle(cornerRadius: 25, style: .continuous))
            .backgroundStyle(.blue.gradient)

    }
}
