//
//  SideMenu.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct MainView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var selectedTab = "Home"
    @State var showMenu = false
    var body: some View {
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
                
                SideManager(selectedTab: $selectedTab)
                    .cornerRadius(showMenu ? 15 : 0)
            }.scaleEffect(showMenu ? 0.84 : 1)
                .offset(x: showMenu ? getRect().width - 120 : 0)
                .ignoresSafeArea()
                .if(Stack.shared.visible == true, transform: { View in
                    View.overlay(
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
                            }.padding(.horizontal, 3)
                        })
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        ,alignment: .topLeading
                    )
                })
        }
        }
    }

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

extension View{
    func getRect()-> CGRect{
        return UIScreen.main.bounds
    }
}
