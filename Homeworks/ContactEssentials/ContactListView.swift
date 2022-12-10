//
//  ContactListView.swift
//  HomeworkBox
//
//  Created by Nate on 12/9/22.
//

import SwiftUI

struct ContactListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GroupChat.name, ascending: true)],
        animation: .default)
    private var groupchats: FetchedResults<GroupChat>
    @State var add = false
    var body: some View {
        NavigationStack{
            List{
                if add{
                    AddGroupView(add: $add)
                }
                ForEach(groupchats){groupchat in
                    GroupChatView(groupchat: groupchat)
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        add.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                    }

                }
            })
            .navigationTitle("GroupChats")
        }
    }
}

struct AddGroupView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var add: Bool
    @State var name = ""
    var body: some View {
        HStack{
            Image(systemName: "person.fill")
                .foregroundColor(name.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
            TextField("Name of GroupChat", text: $name)
                .onSubmit {
                    PersistenceController().addGroupChat(name: name, context: viewContext)
                    add.toggle()
                    name = ""
                }
        }
    }
}
