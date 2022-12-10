//
//  Contact.swift
//  HomeworkBox
//
//  Created by Nate on 12/4/22.
//
import SwiftUI
import Contacts
import ContactsUI

struct AddContactView: View {
    var groupchat: GroupChat
    @Binding var addcontact: Bool
    @State var searchtext = ""
    @State var contact: CNContact = .init()
    @State var contacts: [CNContact] = []
    var body: some View {
        NavigationStack{
            VStack{
                TextField("Contact", text: $searchtext)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        contact = contacts.first ?? .init()
                        if !contacts.isEmpty{
                            PersistenceController().addContact(name: contact.givenName, phonenumber: ShowPhoneNumber(contact: contact), image: contact.imageData ?? .init(), relateTo: groupchat)
                            addcontact.toggle()
                        }
                    }
                if contacts.isEmpty{
                    Image(systemName: "xmark.icloud.fill")
                        .foregroundColor(.red)
                }
            }.padding()
            .onChange(of: searchtext, perform: { newValue in
                Task{
                    await fetchSpecificContacts(searchtext: newValue)
                }
            })
            .onAppear(){
            Task{
                await fetchAllContacts()
            }
        }
    }
    }
    func ShowPhoneNumber(contact: CNContact) -> String{
        for number in contact.phoneNumbers{
            switch number.label{
            default:
                return number.value.stringValue
            }
        }
        return "Nothing"
    }
    
    func fetchSpecificContacts(searchtext: String) async{
        let store  = CNContactStore()
        var tempcontacts: [CNContact] = []
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let predicate = CNContact.predicateForContacts(matchingName: searchtext)
        do{
                tempcontacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
            contacts = tempcontacts
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchAllContacts() async{
        let store = CNContactStore()
        var tempcontacts: [CNContact] = []
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey, CNContactImageDataKey] as [CNKeyDescriptor]
        let fetchrequest = CNContactFetchRequest(keysToFetch: keys)
        do{
            try store.enumerateContacts(with: fetchrequest, usingBlock: { contactenum, result in
                tempcontacts.append(contactenum)
            })
            contacts = tempcontacts
        }catch{
            print(error.localizedDescription)
        }
    }
}

