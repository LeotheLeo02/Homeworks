//
//  NewListView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI

struct NewListItem: View {
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
                    .focused($focname)
                    .submitLabel(.done)
                    .textFieldStyle(.roundedBorder)
                    .bold()
                    .foregroundColor(.blue)
                    .padding()
                    
                    //Add Checkpoints Assign View
                    
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
                    }.padding()
                        .background{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(.ultraThinMaterial)
                                .frame(maxWidth: .infinity)
                        }
                        .padding()
                }.frame(width: 200, height: 200)
                    .background(in: RoundedRectangle(cornerRadius: 25, style: .continuous))
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
            }
        }
        }.onAppear(){
            focname = true
        }
    }
}

struct NewListItem_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension NewListItem {
    @ViewBuilder
    func Cover() -> some View{
        RoundedRectangle(cornerRadius: 25, style: .continuous)
            .frame(width: 200, height: 200)
            .foregroundColor(.blue)
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
        PersistenceController().addAssign(name: name, duedate: duedate, context: viewContext)
        name = ""
        duedate = Date.now
        done = false
    }
}
