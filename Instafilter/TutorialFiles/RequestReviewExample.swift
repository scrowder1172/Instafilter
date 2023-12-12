//
//  RequestReviewExample.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/12/23.
//

import SwiftUI
import StoreKit

struct RequestReviewExample: View {
    
    @Environment(\.requestReview) var requestReview
    
    @State private var clickCount: Int = 0
    
    var body: some View {
        
        Button("Click me") {
            clickCount += 1
            
            if clickCount > 5 {
                requestReview()
                clickCount = 0
            }
        }
        .buttonStyle(.borderedProminent)
        Button("Leave a review") {
            requestReview()
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    RequestReviewExample()
}
