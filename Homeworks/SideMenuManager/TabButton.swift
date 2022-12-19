//
//  TabButton.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//

import SwiftUI

struct TabButton: View {
    var image: String
    var title: String
    
    @Binding var seletedTab: String
    @Binding var dislpaymenu: Bool
    var animation: Namespace.ID
    var body: some View {
        Button {
            withAnimation(.spring()){
                seletedTab = title
                dislpaymenu = false
            }
        } label: {
            HStack(spacing: 15) {
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                
                Text(title)
                    .fontWeight(.semibold)
            }
            .foregroundColor(seletedTab == title ? .blue : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            .frame(maxWidth: getRect().width - 170, alignment: .leading)
            .background(
                ZStack{
                    if seletedTab == title{
                        Color(.white)
                            .opacity(seletedTab == title ? 1 : 0)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 12))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
        }

    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
