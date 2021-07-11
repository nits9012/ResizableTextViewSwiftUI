//
//  ContentView.swift
//  ResizeableTextView
//
//  Created by Nitin Bhatt on 7/5/21.
//

import SwiftUI

struct ContentView: View {
    @State var textViewValue = String()
    @State var textViewHeight:CGFloat = 50.0
    
    var body: some View {
        VStack{
          HStack{
            ResizeableTextView(text: $textViewValue, height: $textViewHeight, placeholderText: "Type a message").frame(height: textViewHeight < 160 ? self.textViewHeight : 160).cornerRadius(20)
          }.padding(20)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct ResizeableTextView: UIViewRepresentable{
    @Binding var text:String
    @Binding var height:CGFloat
    var placeholderText: String
    @State var editing:Bool = false
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = true
        textView.isScrollEnabled = true
        textView.text = placeholderText
        textView.delegate = context.coordinator
        textView.textColor = UIColor.white
        textView.backgroundColor = UIColor.black
        textView.font = UIFont.systemFont(ofSize: 20)
        return textView
    }
    
    func updateUIView(_ textView: UITextView, context: Context) {
        if self.text.isEmpty == true{
            textView.text = self.editing ? "" : self.placeholderText
            textView.textColor = self.editing ? .white : .lightGray
        }
        
        DispatchQueue.main.async {
            self.height = textView.contentSize.height
            textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        ResizeableTextView.Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate{
        var parent: ResizeableTextView
        
        init(_ params: ResizeableTextView) {
            self.parent = params
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
               self.parent.editing = true
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            DispatchQueue.main.async {
               self.parent.editing = false
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            DispatchQueue.main.async {
                self.parent.height = textView.contentSize.height
                self.parent.text = textView.text
            }
        }
        
        
    }
    
}
