//
//  Tryout.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI
import Contacts
import ContactsUI

struct ContactsPicker: View {
    @State private var showContacts = false
    @State private var selectedContact: CNContact?
    
    var body: some View {
        VStack {
            if selectedContact != nil {
                Text("Selected contact: \(selectedContact!.givenName) \(selectedContact!.familyName)")
            } else {
                Text("No contact selected")
            }
            
            Button("Select contact") {
                self.showContacts = true
            }
        }
        .sheet(isPresented: $showContacts) {
            ContactPickerView(selectedContact: self.$selectedContact)
        }
    }
}
