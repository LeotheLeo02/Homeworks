//
//  ViewChecks.swift
//  Homeworks
//
//  Created by Nate on 11/26/22.
//

import SwiftUI

struct ViewChecks: View {
    @Environment(\.managedObjectContext) private var viewContext
    var assign: Assignment
    init(assign: Assignment) {
        self.assign = assign
        let nsFetchRequest = Checkpoint.fetchRequest()
        nsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Checkpoint.deadline, ascending: true)]
        nsFetchRequest.predicate = NSPredicate(format: "assign = %@", assign)
        fetchRequest = FetchRequest(fetchRequest: nsFetchRequest, animation: .default)
    }
    private let fetchRequest: FetchRequest<Checkpoint>
    private var checkpoints: FetchedResults<Checkpoint> {
        return fetchRequest.wrappedValue
    }
    var body: some View {
        ScrollView{
            VStack{
                ForEach(checkpoints) { checkpoint in
                    Image(systemName: "mappin.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.red)
                        .overlay {
                            HStack{
                                Text(checkpoint.name ?? "")
                                Text(checkpoint.deadline ?? .now, style: .timer)
                            }.font(.largeTitle.bold())
                                .foregroundColor(.white)
                        }
                        .contextMenu{
                            Button(role: .destructive) {
                                PersistenceController().deleteCheckpoint(checkpoint: checkpoint, context: viewContext)
                            } label: {
                                Text("Delete")
                                Image(systemName: "trash")
                            }

                        }
                }
            }
        }.background{
            Rectangle()
                .scaledToFill()
                .foregroundColor(.black)
                .ignoresSafeArea()
        }
    }
}
