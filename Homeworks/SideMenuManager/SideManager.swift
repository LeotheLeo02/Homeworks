//
//  HomeTest.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct SideManager: View {
    @Binding var selectedTab: String
    
    init(selectedTab: Binding<String>, addtest: Binding<Bool>, addnew: Binding<Bool>, datepicker: Binding<Bool>, duedate: Binding<Date>, editing: Binding<Bool>) {
        self._selectedTab = selectedTab
        self._addnew = addnew
        self._addtest = addnew
        self._editing = editing
        self._datepicker = datepicker
        self._duedate = duedate
        UITabBar.appearance().isHidden = true
    }
    @Binding var addtest: Bool
    @Binding var addnew: Bool
    @Binding var datepicker: Bool
    @Binding var duedate: Date
    @Binding var editing: Bool
    var body: some View {
        TabView(selection: $selectedTab) {
            Home(addtest: $addtest, addnew: $addnew, datepicker: $datepicker, duedate: $duedate, editing: $editing)
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
