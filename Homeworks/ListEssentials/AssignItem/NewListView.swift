//
//  NewListView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI

struct NewAssignItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isRotating = 0.0
    @FocusState var focname: Bool
    @State var done = false
    @Binding var addnew: Bool
    @Binding var duedate: Date
    @Binding var editing: Bool
    @Binding var datepicker: Bool
    @State private var name = ""
    var body: some View {
        VStack{
            ZStack{
                VStack{
                    TextField("Name", text: $name, onEditingChanged: { bool in
                        editing = bool
                    })
                    .font(.subheadline.bold())
                    .focused($focname)
                    .submitLabel(.done)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(.blue)
                    .padding()
                    Spacer()
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
                        .buttonStyle(.borderedProminent)
                        .cornerRadius(.infinity)
                    }.padding(10)
                        .background{
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.ultraThinMaterial)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.pi)
                }.frame(width: 170, height: 170)
                    .background(in: RoundedRectangle(cornerRadius: 5))
                    .backgroundStyle(.blue.gradient)
                if done {
                    Cover()
                }
            }
            if !done{
                Button {
                withAnimation(.spring()){
                    done = true
                    SoundManager.instance.playSound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        Add()
                    }
                }
            } label: {
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }.disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        }.onAppear(){
            focname = true
        }
    }
}

extension NewAssignItem {
    @ViewBuilder
    func Cover() -> some View{
        RoundedRectangle(cornerRadius: 5)
            .frame(width: 170, height: 170)
            .foregroundStyle(.blue.gradient)
            .overlay {
                VStack{
                    Image(systemName: "backpack.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                    Image(systemName: "checkmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(isRotating))
                        .onAppear {
                            withAnimation(.spring()){
                                isRotating = 360.0
                            }
                        }
                }.padding()
            }
    }
    
    func Add(){
        addnew = false
        AssignController().addAssign(name: name, duedate: duedate, context: viewContext)
        name = ""
        duedate = Date.now
        done = false
        isRotating = 0
    }
}
