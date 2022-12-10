//
//  GroupChatView.swift
//  HomeworkBox
//
//  Created by Nate on 12/9/22.
//
import SwiftUI

struct GroupChatView: View{
    var groupchat: GroupChat
    init(groupchat: GroupChat) {
        self.groupchat = groupchat
        let nsFetchRequest = Contact.fetchRequest()
        nsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Contact.name, ascending: true)]
        nsFetchRequest.predicate = NSPredicate(format: "groupchat = %@", groupchat)
        fetchRequest = FetchRequest(fetchRequest: nsFetchRequest, animation: .default)
    }
    
    private let fetchRequest: FetchRequest<Contact>
    private var contacts: FetchedResults<Contact> {
        return fetchRequest.wrappedValue
    }
    @State var addcontact = false
    var body: some View{
        VStack{
        HStack{
            Text(groupchat.name ?? "")
            Spacer()
            Button {
                addcontact.toggle()
            } label: {
                Image(systemName: "person.crop.circle.badge.plus")
            }.buttonBorderShape(.capsule)
                .buttonStyle(.borderedProminent)
        }
            HStack{
                ForEach(contacts){contact in
                    Image(systemName: "person.circle.fill")
                        .font(.title)
                    Text(contact.phonenumber ?? "")
                }
            }
            if !contacts.isEmpty{
                Button {
                    Facetime()
                } label: {
                    Text("Call")
                    Image(systemName: "phone.fill")
                }.buttonStyle(.bordered)
            }

            if addcontact{
                AddContactView(groupchat: groupchat, addcontact: $addcontact)
            }
    }
    }
    private func Facetime() {
        var phonenumbers = ""
        for contact in contacts {
            let number = ("\(contact.phonenumber?.stringByRemovingAll(characters: [")","(", " ", "-"]) ?? "");")
            phonenumbers.append(number)
            
        }
            print(phonenumbers)
            if let url = URL(string: "facetime-group://?remoteMembers=\(phonenumbers)"){
                UIApplication.shared.open(url)
            }else{
                print("Did not work")
            }
    }
}
extension String {
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
}
