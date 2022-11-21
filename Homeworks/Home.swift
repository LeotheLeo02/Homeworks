//
//  ContentView.swift
//  Homeworks
//
//  Created by Nate on 11/21/22.
//

import SwiftUI
import CoreData

struct Home: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Assignment.name, ascending: true)],
        animation: .default)
    private var assignments: FetchedResults<Assignment>

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack{
                    Text("Hi")
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .overlay {
                    HStack{
                        Text("Assignments")
                            .foregroundColor(.white)
                            .font(.title3.bold())
                            .padding()
                    }.background{
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .top)
                        .padding(.top, 30)
                }
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Home().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
