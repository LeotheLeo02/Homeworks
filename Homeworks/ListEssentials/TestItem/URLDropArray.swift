//
//  URLDropArray.swift
//  Homeworks
//
//  Created by Nate on 12/3/22.
//

import SwiftUI

struct URLDropArray: View {
    var test: Assessment
    init(test: Assessment) {
        self.test = test
        let nsFetchRequest = Refurl.fetchRequest()
        nsFetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Refurl.dateadded, ascending: true)]
        nsFetchRequest.predicate = NSPredicate(format: "assessment = %@", test)
        fetchRequest = FetchRequest(fetchRequest: nsFetchRequest, animation: .default)
    }
    private let fetchRequest: FetchRequest<Refurl>
    private var urls: FetchedResults<Refurl> {
        return fetchRequest.wrappedValue
    }
    @State private var name = ""
    @State private var addname = false
    @State private var links: [URL] = []
    var body: some View {
        Image(systemName: "cursorarrow.and.square.on.square.dashed")
            .bold()
        Text("Links:")
            .bold()
        ScrollView(.horizontal){
            HStack{
            ForEach(urls){url in
                if url.url?.pathExtension == "pdf"{
                    NavigationLink(destination: PDFKitRepresentedView(url.url ?? .downloadsDirectory)) {
                    HStack{
                        Text(url.name ?? "")
                        Image(systemName: "doc.fill")
                            .onDrag { NSItemProvider(object: url.url! as NSURL) }
                    } .padding(.horizontal, .pi)
                        .background(Color(.white))
                        .cornerRadius(20)
                        .foregroundColor(.black)
                }
                }else{
                    Link(url.name ?? "", destination: url.url!)
                        .onDrag { NSItemProvider(object: url.url! as NSURL) }
                        .padding(.horizontal, .pi)
                        .background(Color(.white))
                        .cornerRadius(20)
                }
            }
        }
        .onChange(of: links, perform: { link in
            addname.toggle()
        })
        .padding()
        .alert("Add Link", isPresented: $addname, actions: {
            TextField("Name", text: $name)
            Button("Add", action: {AssesController().addURL(url: links.first!, name: name, relateTo: test)})
            Button("Cancel", role: .cancel, action: {})
        }, message: {
            Text("Enter Name For URL")
        })
    }.onDrop(
        of: ["public.url"],
        delegate: URLDropDelegate(urls: $links)
    )
    }
}






struct URLDropDelegate: DropDelegate {
    @Binding var urls: [URL]
    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: ["public.url"]) else {
            return false
        }

        let items = info.itemProviders(for: ["public.url"])
        for item in items {
            _ = item.loadObject(ofClass: URL.self) { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.urls.insert(url, at: 0)
                    }
                }
            }
        }

        return true
    }
}
