//
//  NewTestItem.swift
//  Homeworks
//
//  Created by Nate on 11/30/22.
//

import SwiftUI

struct NewTestItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FocusState var focname: Bool
    @State var done = false
    @State private var isRotating = 0.0
    @Binding var addtest: Bool
    @Binding var duedate: Date
    @Binding var editing: Bool
    @Binding var datepicker: Bool
    @State private var name = ""
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    TextField("Name", text: $name, onEditingChanged: { bool in
                        editing = bool
                    })
                    .focused($focname)
                    .textFieldStyle(.roundedBorder)
                }.padding()
                HStack{
                    Text("\(duedate.formatted(date: .abbreviated, time: .shortened))")
                        .font(.headline.bold())
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
                    .padding(5)
                    .background(.gray)
                    .cornerRadius(25)
                }.padding()
                    .background{
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
            }.frame(maxWidth: .infinity, maxHeight: 200)
                .background(in: RoundedRectangle(cornerRadius: 5))
                .backgroundStyle(.gray.gradient)
                .onAppear(){
                    focname.toggle()
                }
            if done {
                Cover()
            }
        }
        HStack{
            Spacer()
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
            }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
            Spacer()
    }
        }
    }
extension NewTestItem {
    @ViewBuilder
    func Cover() -> some View{
        RoundedRectangle(cornerRadius: 5)
            .frame(maxWidth: .infinity, maxHeight: 200)
            .foregroundStyle(.gray.gradient)
            .overlay {
                VStack{
                    Image(systemName: "clipboard")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.white)
                        .overlay {
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
                                .padding()
                        }
                        .padding()
                }.padding()
            }
    }
    
    func Add(){
        editing = false
        addtest = false
        PersistenceController().addAsses(name: name, testdate: duedate, context: viewContext)
        name = ""
        duedate = Date.now
        done = false
        isRotating = 0
    }
}
