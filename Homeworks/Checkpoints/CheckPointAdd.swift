//
//  CheckPointAdd.swift
//  Homeworks
//
//  Created by Nate on 11/24/22.
//

import SwiftUI

struct CheckPointAdd: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    var assign: Assignment
    init(assign: Assignment) {
        self.assign = assign
    }
    @FocusState var focnam: Bool
    @State var next = false
    @State var add = false
    @State var name = ""
    @State var deadline = Date()
    @State var Checkpoints: [CheckpointItem] = []
    var body: some View {
        NavigationView{
        ScrollView{
            HStack{
                Text("Add Checkpoints")
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.red)
            }.font(.largeTitle.bold())
            VStack{
                FillOutView()
                    .background{
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .foregroundColor(Color(.systemGray6))
                            .font(.largeTitle)
                    }
                BottomBarView()
            }.padding()
                .background{
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(.red)
                }
                .overlay {
                    if add{
                        ZStack{
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .foregroundColor(.green)
                            Image(systemName: "checkmark")
                                .bold()
                                .foregroundColor(.white)
                        }
                    }
                }
            ForEachList()
        }.padding()
            .onAppear(){
                focnam = true
            }
        
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        AddToCore()
                    } label: {
                        Text("Add Checkpoints")
                            .foregroundColor(.blue)
                            .bold()
                    }.buttonStyle(.bordered)
                        .cornerRadius(.infinity)
                    
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .bold()
                    }.buttonStyle(.bordered)
                        .cornerRadius(.infinity)
                }
            }
    }
    }
}

extension CheckPointAdd{
    @ViewBuilder
    func ForEachList() -> some View{
        HStack{
            Text("Checkpoints:")
                .underline()
                .bold()
            Spacer()
        }.padding()
        Divider()
        if Checkpoints.isEmpty{
            Text("No Checkpoints Being Added")
                .foregroundColor(.gray)
                .italic()
        }
        ForEach(Checkpoints.sorted()) { checkpoint in
            HStack{
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.red)
                Text(checkpoint.name)
                Text(checkpoint.deadline, style: .date)
                    .foregroundColor(.red)
                    .font(.caption)
                Text(checkpoint.deadline, style: .time)
                    .foregroundColor(.red)
                    .font(.caption)
            }.foregroundColor(colorScheme == .dark ? .black : .white)
                .padding()
                .background{
                    Capsule()
                }
        }
    }
    func AddToCore(){
        for checkpoint in Checkpoints {
            PersistenceController().addCheckPoint(name: checkpoint.name, deadline: checkpoint.deadline, relateTo: assign)
        }
        dismiss()
    }
    @ViewBuilder
    func FillOutView() -> some View{
        HStack{
            if next{
                DatePicker("", selection: $deadline, in: Date.now...)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding()
            }else{
                TextField("Checkpoint Name...", text: $name)
                    .focused($focnam)
                    .padding()
                    .foregroundColor(.red)
                    .bold()
            }
    }
    }
    @ViewBuilder
    func BottomBarView() -> some View{
        HStack{
            Spacer()
            if next {
                Button {
                    withAnimation(.easeIn){
                        add = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                            Checkpoints.append(CheckpointItem(name: name, deadline: deadline))
                            next = false
                            add = false
                            name = ""
                            deadline = Date.now
                        }
                    }
                    
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.green)
                        .font(.largeTitle)
                }
            }else{
                Button {
                    withAnimation(.linear){
                        next = true
                    }
                } label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .if(name.trimmingCharacters(in: .whitespaces).isEmpty, transform: { Image in
                            Image.foregroundStyle(.ultraThinMaterial)
                        })
                        .if(!name.trimmingCharacters(in: .whitespaces).isEmpty, transform: { Image in
                                Image.foregroundColor(.black)
                        })
                        .font(.largeTitle)
                }.disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
            }
        }
    }
}

struct CheckpointItem: Identifiable, Comparable{
    var id = UUID()
    var name: String
    var deadline: Date
    
    static func <(lhs: CheckpointItem, rhs: CheckpointItem) -> Bool {
        return lhs.deadline < rhs.deadline
    }
}
