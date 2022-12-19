//
//  SideMenu.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab = "Main"
    @State var showMenu = false
    
    @State var addtest = false
    @State var addnew = false
    @State var datepicker = false
    @State var duedate = Date.now
    @State var editing = false
    var body: some View {
        NavigationStack{
        ZStack{
            Color(.systemBlue)
                .ignoresSafeArea()
            
            SideMenu(selectedTab: $selectedTab, showmenu: $showMenu)
            ZStack{
                Color(colorScheme == .dark ? .black:.white)
                    .opacity(0.5)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -25 : 0)
                    .padding(.vertical, 30)
                
                Color(colorScheme == .dark ? .black:.white)
                    .opacity(0.4)
                    .cornerRadius(showMenu ? 15 : 0)
                    .shadow(color: Color.black.opacity(0.07), radius: 5, x: -5, y: 0)
                    .offset(x: showMenu ? -50 : 0)
                    .padding(.vertical, 60)
                
                SideManager(selectedTab: $selectedTab, addtest: $addtest, addnew: $addnew, datepicker: $datepicker, duedate: $duedate, editing: $editing)
                    .cornerRadius(showMenu ? 15 : 0)
            }.scaleEffect(showMenu ? 0.84 : 1)
                .offset(x: showMenu ? getRect().width - 120 : 0)
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                if !addnew && !addtest{
                    Button(action: {
                        withAnimation(.spring()){
                            showMenu.toggle()
                        }
                    }, label: {
                        VStack(spacing: 5) {
                            Capsule()
                                .fill(showMenu ? .white : .primary)
                                .frame(width: 30, height: 3)
                                .rotationEffect(.init(degrees: showMenu ? -50 : 0))
                                .offset(x: showMenu ? 2 : 0, y: showMenu ? 9 : 0)
                            VStack(spacing: 5){
                                Capsule()
                                    .fill(showMenu ? .white : .primary)
                                    .frame(width: 30, height: 3)
                                Capsule()
                                    .fill(showMenu ? .white : .primary)
                                    .frame(width: 30, height: 3)
                                    .offset(y: showMenu ? -8 : 0)
                            }.rotationEffect(.init(degrees: showMenu ? 50 : 0))
                        }
                    })
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                if editing{
                    DoneButton(date: 2)
                }
            }
            ToolbarItem(placement: .cancellationAction) {
                if addnew || addtest && !datepicker{
                    DoneButton(date: 3)
                }
            }
            if datepicker{
                ToolbarItem(placement: .confirmationAction) {
                    DoneButton(date: 1)
                }
            }
        }
    }
        }
    }
extension MainView{
    @ViewBuilder
    //Done button to finish textfield or datepicker
    func DoneButton(date: Int) -> some View{
                Button {
                    withAnimation {
                        if date == 1{
                            datepicker = false
                        }else if date == 2{
                            editing = false
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }else{
                            addnew = false
                            editing = false
                            addtest = false
                        }
                    }
                } label: {
                    if date == 3{
                        Text("Cancel")
                            .bold()
                            .foregroundColor(.red)
                    }else{
                        Text("Done")
                            .bold()
                            .foregroundColor(.blue)
                    }
                }.buttonStyle(.bordered)
                    .cornerRadius(.infinity)
    }
}

extension View{
    func getRect()-> CGRect{
        return UIScreen.main.bounds
    }
}
