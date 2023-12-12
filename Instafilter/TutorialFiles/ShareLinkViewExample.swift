//
//  ShareLinkViewExample.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/12/23.
//

import SwiftUI

struct ShareLinkViewExample: View {
    var body: some View {
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!)
        
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!,
                  subject: Text("Learn Swift Here"), message: Text("Take 100 Days of SwiftUI"))
        
        ShareLink(item: URL(string: "https://www.hackingwithswift.com")!) {
            Label("Spread the word about Swift", systemImage: "swift")
        }
        
        let exampleImage: Image = Image(.example)
        ShareLink(item: exampleImage, preview: SharePreview("Landscape", image: exampleImage)) {
            Label("Click to Share Image", systemImage: "photo")
        }
    }
}

#Preview {
    ShareLinkViewExample()
}
