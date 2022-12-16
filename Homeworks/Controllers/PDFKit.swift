//
//  Tryout.swift
//  HomeworkBox
//
//  Created by Nate on 12/10/22.
//
import SwiftUI
import PDFKit



struct PDFQuickView: View{
    @Environment(\.dismiss) var dismiss
    var url: URL
    init(url: URL) {
        self.url = url
    }
    var body: some View{
        VStack{
            HStack{
                Button {
                    dismiss()
                    Stack.shared.updateValue(newValue: true)
                } label: {
                    Image(systemName: "arrowshape.left.fill")
                }
                Spacer()
            }.padding()
                .padding(.top, 50)
                .onAppear(){
                    Stack.shared.updateValue(newValue: false)
                    print(Stack.shared.visible)
                }
            PDFKitRepresentedView(url)
        }.navigationBarHidden(true)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL

    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        // Create a `PDFView` and set its `PDFDocument`.
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: self.url)
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        
    }
}
