//
//  CheckPointAdd.swift
//  Homeworks
//
//  Created by Nate on 11/24/22.
//

import SwiftUI

struct CheckPointAdd: View {
    var assign: Assignment
    init(assign: Assignment) {
        self.assign = assign
    }
    @FocusState var focnam: Bool
    @State var add = false
    @State var name = ""
    @State var deadline = Date()
    @State var Checkpoints: [CheckpointItem] = []
    var body: some View {
        VStack{
            HStack{
                Text("Add Checkpoints")
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.green)
            }.font(.largeTitle.bold())
            VStack{
            TextField("Checkpoint Name...", text: $name, axis: .vertical)
                .focused($focnam)
                .padding()
                .foregroundColor(.green)
                .bold()
                .background{
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .foregroundColor(Color(.systemGray6))
                        .font(.largeTitle)
                }
            HStack{
                DatePicker("", selection: $deadline, in: Date.now...)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                Button {
                    add.toggle()
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                }
                
            }
            }.padding()
            .background{
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.blue.opacity(0.9))
                    .shadow(color: .blue.opacity(0.9), radius: 10)
            }
        }.padding()
            .onAppear(){
                focnam = true
            }
    }
}


struct CheckpointItem: Identifiable{
    var id = UUID()
    var name: String
    var deadline: Date
}
