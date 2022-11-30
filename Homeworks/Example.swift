//
//  Leo.swift
//  Homeworks
//
//  Created by Nate on 11/29/22.
//

import SwiftUI

struct BookmarksList: View {
    @State private var links: [URL] = [
        URL(string: "https://twitter.com/mecid")!
    ]
    
    var body: some View {
        List {
            ForEach(links, id: \.self) { url in
                Text(url.absoluteString)
                    .onDrag { NSItemProvider(object: url as NSURL) }
            }
            .onDrop(
                of: ["public.url"],
                delegate: BookmarksDropDelegate(bookmarks: $links)
            )
        }
        .navigationBarTitle("Bookmarks")
    }
}

struct BookmarksDropDelegate: DropDelegate {
    @Binding var bookmarks: [URL]

    func performDrop(info: DropInfo) -> Bool {
        guard info.hasItemsConforming(to: ["public.url"]) else {
            return false
        }

        let items = info.itemProviders(for: ["public.url"])
        for item in items {
            _ = item.loadObject(ofClass: URL.self) { url, _ in
                if let url = url {
                    DispatchQueue.main.async {
                        self.bookmarks.insert(url, at: 0)
                    }
                }
            }
        }

        return true
    }
}
