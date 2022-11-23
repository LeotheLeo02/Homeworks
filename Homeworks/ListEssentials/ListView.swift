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
    var assign: Assignment
    init(assign: Assignment) {
        self.assign = assign
    }
    var body: some View{
        VStack{
            Text("\(assign.name ?? "")")
                .bold()
                .foregroundColor(.white)
                .padding(.top, 20)
            
            //Add Checkpoints Quick View
            
            Spacer()
            HStack{
                Spacer()
                Text("Due Today!")
                    .bold()
                Spacer()
            }.padding()
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
