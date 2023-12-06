//
//  BlurView.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/6/23.
//

import SwiftUI

struct BlurView: View {
    
    @State private var blurAmount: Double = 0.0 {
        didSet {
            print("Blur value change via @State: \(blurAmount)")
        }
    }
    
    var body: some View {
        VStack {
            Text("Secret message")
                .blur(radius: blurAmount)
            
            HStack {
                Text("Hide Message:")
                Slider(value: $blurAmount, in: 0...20)
            }
            
            Button("Random Blur") {
                blurAmount = Double.random(in: 0...20)
            }
            .frame(width: 200, height: 50)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 10))
            .onChange(of: blurAmount) { oldValue, newValue in
                print("Blur value change via onChange Modifier: old value(\(oldValue) new value (\(newValue)")
            }
            
            Button("Show Message") {
                blurAmount = 0.0
            }
            .frame(width: 200, height: 50)
            .background(.yellow)
            .clipShape(.rect(cornerRadius: 10))
        }
        .padding()
    }
}

#Preview {
    BlurView()
}
