//
//  SideMenu.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct SideMenu: View {
    @Binding var selectedTab: String
    @Namespace var animation
    @Binding var showmenu: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 15){
            
            Image("profile")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                .padding(.top, 50)
            
            VStack(alignment: .leading,spacing: 6) {
                Text("Name")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Button {
                    
                } label: {
                    Text("View Profile")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .opacity(0.7)
                }

            }
            VStack(alignment: .leading, spacing: 10){
                TabButton(image: "house", title: "Home", seletedTab: $selectedTab, showmenu: $showmenu, animation: animation)
                
                TabButton(image: "person.3.fill", title: "GroupChat", seletedTab: $selectedTab, showmenu: $showmenu, animation: animation)
            }
            .padding(.leading, -15)
            .padding(.top, 50)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                TabButton(image: "gear", title: "Settings", seletedTab: $selectedTab, showmenu: $showmenu, animation: animation)
                    .padding(.leading, -15)
                
                Text("App Version 0.6.1")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.6)
            }
        }.padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
