//
//  TabManager.swift
//  HomeworkBox
//
//  Created by Nate on 12/9/22.
//

import SwiftUI

struct TabManager: View {
    var body: some View {
        TabView{
            Home()
                .tabItem {
                    Text("Workspace")
                    Image(systemName: "doc.text.image.fill")
                }
            ContactListView()
                .tabItem {
                    Text("GroupChats")
                    Image(systemName: "person.3.fill")
                }
        }
    }
}

struct TabManager_Previews: PreviewProvider {
    static var previews: some View {
        TabManager()
    }
}
