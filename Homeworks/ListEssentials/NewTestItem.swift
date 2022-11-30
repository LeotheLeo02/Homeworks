//
//  NewTestItem.swift
//  Homeworks
//
//  Created by Nate on 11/30/22.
//

import SwiftUI

struct NewTestItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var addtest: Bool
    @Binding var duedate: Date
    @Binding var editing: Bool
    @Binding var datepicker: Bool
    @State private var name = ""
    var body: some View {
        VStack{
            HStack{
                TextField("Name", text: $name, onEditingChanged: { bool in
                    editing = bool
                })
                .textFieldStyle(.roundedBorder)
            }.padding()
            HStack{
                Text("\(duedate.formatted(date: .abbreviated, time: .shortened))")
                    .font(.caption2.bold())
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
                Button {
                    withAnimation {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        datepicker.toggle()
                    }
                } label: {
                    Image(systemName: "calendar.badge.plus")
                        .font(.title3.bold())
                        .foregroundColor(.black)
                }
                .padding(.pi)
                .background(.gray)
                .cornerRadius(25)
            }.padding()
                .background{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(.ultraThinMaterial)
                        .frame(maxWidth: .infinity)
                }
                .padding()
        }.frame(maxWidth: .infinity, maxHeight: 200)
            .background(in: RoundedRectangle(cornerRadius: 25))
            .backgroundStyle(.gray.gradient)
            .padding()
    }
}
