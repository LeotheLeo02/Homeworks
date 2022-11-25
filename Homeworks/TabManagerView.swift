//
//  TabManagerView.swift
//  Homeworks
//
//  Created by Nate on 11/24/22.
//

import SwiftUI

struct TabManagerView: View {
    var body: some View {
        TabView{
            Home()
                .tabItem {
                    Text("Home")
                    Image(systemName: "house.fill")
                }
        }
    }
}

struct TabManagerView_Previews: PreviewProvider {
    static var previews: some View {
        TabManagerView()
    }
}
