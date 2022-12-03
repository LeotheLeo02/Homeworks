//
//  AssignItem.swift
//  Homeworks
//
//  Created by Nate on 12/3/22.
//

import SwiftUI

struct AssignItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var checkpointadd = false
    @State var viewchecks = false
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
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Menu{
                        Button {
                            checkpointadd.toggle()
                        } label: {
                            Text("Add Checkpoint")
                            Image(systemName: "mappin.and.ellipse")
                        }
                }label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.white)
                }
                .padding(5)
            }
            Text("\(assign.name ?? "")")
                .bold()
                .font(.title3)
                .foregroundColor(.white)
            ForEach(checkpoints.prefix(1)){checkpoint in
                CheckpointView(checkpoint: checkpoint)
                    .fullScreenCover(isPresented: $viewchecks) {
                        ViewChecks(assign: assign)
                    }
            }
            Spacer(minLength: 5)
            HStack{
                Spacer()
                Text(assign.duedate ?? .now, style: .relative)
                    .bold()
                Spacer()
            }.padding(10)
                .background{
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.ultraThinMaterial)
                        .frame(maxWidth: .infinity, maxHeight: 40)
                }
        }.frame(width: 170, height: 170)
            .background(in: RoundedRectangle(cornerRadius: 5))
            .if(!checkpoints.isEmpty, transform: { View in
                View.backgroundStyle(CalculateColor(from: Date.now, to: checkpoints.first?.deadline ?? .now).gradient)
            })
                .if(checkpoints.isEmpty, transform: { View in
                    View.backgroundStyle(.gray.gradient)
                })
            .fullScreenCover(isPresented: $checkpointadd) {
                CheckPointAdd(assign: assign)
            }
    }

    }

extension AssignItem{
    @ViewBuilder
    func CheckpointView(checkpoint: Checkpoint) -> some View {
        VStack{
                Text(checkpoint.name ?? "")
                .foregroundColor(.black.opacity(0.5))
                .padding(.pi)
            if checkpoint.deadline ?? .now < Date.now{
                Button {
                    PersistenceController().deleteCheckpoint(checkpoint: checkpoint, context: viewContext)
                } label: {
                    Image(systemName: "checkmark")
                }.padding(.pi)
                .background{Circle().foregroundColor(.green)}

            }else{
                Menu{
                    Button {
                        viewchecks.toggle()
                    } label: {
                        Text("View Checkpoints")
                        Image(systemName: "eye")
                    }
                }label: {
                    Text(checkpoint.deadline ?? .now, style: .relative)
                        .font(.caption2)
                        .foregroundColor(.black.opacity(0.6))
                        .fixedSize(horizontal: true, vertical: false)
                }
            }
            //Change to Checkpoint Name
        }.font(.headline).bold()
            .foregroundColor(.white)
    }
    func CalculateColor(from fromDate: Date, to toDate: Date) -> Color{
        let timeinterval = toDate.timeIntervalSince(fromDate)
        if timeinterval <= 86400 {
            return .red
        }
        if timeinterval <=  259200 && timeinterval > 86400{
            return .yellow
        }
        if timeinterval >= 345600 && timeinterval > 25900{
            return .blue
        }
        return .gray
    }
}
