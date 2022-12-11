//
//  GroupChatView.swift
//  HomeworkBox
//
//  Created by Nate on 12/9/22.
//
import SwiftUI
import ContactsUI
import UIKit
import CoreGraphics

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
    @State private var selectedContact: CNContact?
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
                .onChange(of: selectedContact) { newValue in
                    PersistenceController().addContact(name: selectedContact?.givenName ?? "Nil", phonenumber: ShowPhoneNumber(contact: selectedContact!), image: selectedContact?.imageData ?? .init(), relateTo: groupchat)
                }
        }
            HStack{
                ForEach(contacts){contact in
                    let uiimage =  UIImage(data: contact.image ?? .init())
                    Image(uiImage: uiimage ?? makeInitialsImage(from: contact.name ?? ""))
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
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
        }.sheet(isPresented: $addcontact) {
            ContactPickerView(selectedContact: self.$selectedContact)
        }
    }
}
extension String {
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
}


extension GroupChatView{
    func makeInitialsImage(from contact: String) -> UIImage {
        let initials = contact
        let font = UIFont.systemFont(ofSize: 20)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.white
        ]
        
        // Create a blank image with a size of 100x100 pixels
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 100, height: 100))
        let image = renderer.image { ctx in
            // Fill the background of the image with a blue color
            UIColor.systemBlue.setFill()
            ctx.fill(CGRect(x: 0, y: 0, width: 100, height: 100))
            
            // Draw the contact's initials on top of the blue background
            let attributedInitials = NSAttributedString(string: initials, attributes: attributes)
            let textSize = attributedInitials.size()
            let x = (100 - textSize.width) / 2
            let y = (100 - textSize.height) / 2
            attributedInitials.draw(at: CGPoint(x: x, y: y))
        }
        
        return image
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
