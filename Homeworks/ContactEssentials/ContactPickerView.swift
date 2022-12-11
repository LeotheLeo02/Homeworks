//
//  Contact.swift
//  HomeworkBox
//
//  Created by Nate on 12/4/22.
//
import SwiftUI
import ContactsUI

struct ContactPickerView: UIViewControllerRepresentable {
    
    @Binding var selectedContact: CNContact?

    func makeUIViewController(context: Context) -> CNContactPickerViewController {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = context.coordinator
        return contactPicker
    }

    func updateUIViewController(_ uiViewController: CNContactPickerViewController, context: Context) {
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, CNContactPickerDelegate {
        var parent: ContactPickerView

        init(_ parent: ContactPickerView) {
            self.parent = parent
        }

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            parent.selectedContact = contact
        }
    }
}

