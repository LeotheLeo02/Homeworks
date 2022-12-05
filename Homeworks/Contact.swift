//
//  Contact.swift
//  HomeworkBox
//
//  Created by Nate on 12/4/22.
//
import SwiftUI
import Contacts

struct Contact: View {
    @State var contacts: [CNContact] = []
    var body: some View {
        List{
            ForEach(contacts, id: \.self){contact in
                HStack{
                    Text(contact.givenName)
                    Spacer()
                    Text(ShowPhoneNumber(contact:contact))
                    Button {
                        Facetime(phoneNumber: ShowPhoneNumber(contact: contact))
                    } label: {
                        Text("FaceTime")
                        Image(systemName: "phone.circle.fill")
                    }.buttonStyle(.bordered)
                }.padding()

            }
        }.onAppear(){
            Task{
               await fetchAllContacts()
            }
        }
    }
    private func Facetime(phoneNumber:String) {
        
        guard let url = URL(string: "facetime-group://?remoteMembers=+\(phoneNumber);+2104009440&isVideoEnabled=1") else { return }
        UIApplication.shared.open(url)
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
    
    func fetchSpecificContacts() async{
        let store  = CNContactStore()
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        let predicate = CNContact.predicateForContacts(matchingName: "Kate")
        do{
           contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keys)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    func fetchAllContacts() async {
        let store = CNContactStore()
        
        let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey] as [CNKeyDescriptor]
        
        let fetchrequest = CNContactFetchRequest(keysToFetch: keys)
        
        do{
            try store.enumerateContacts(with: fetchrequest, usingBlock: { contactenum, result in
                contacts.append(contactenum)
            })
        }catch{
            print(error.localizedDescription)
        }
    }
}

struct Contact_Previews: PreviewProvider {
    static var previews: some View {
        Contact()
    }
}
