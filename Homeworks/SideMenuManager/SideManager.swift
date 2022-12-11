//
//  HomeTest.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct SideManager: View {
    @Binding var selectedTab: String
    
    init(selectedTab: Binding<String>) {
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
    }
    var body: some View {
        TabView(selection: $selectedTab) {
            Home()
                .tag("Home")
            
            ContactListView()
                .tag("GroupChat")
        }
    }
}

struct HomeTest_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
