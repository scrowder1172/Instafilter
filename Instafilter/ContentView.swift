//
//  ContentView.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/6/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var processedImage: Image?
    @State private var filterIntensity: Float = 0.5
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                if let processedImage {
                    processedImage
                        .resizable()
                        .scaledToFit()
                } else {
                    ContentUnavailableView {
                        Label("No Picture", systemImage: "square.and.pencil.circle.fill")
                    } description: {
                        Text("Tap to import a photo")
                    }
                }
                
                Spacer()
                
                HStack {
                    Text("Intensity")
                    Slider(value: $filterIntensity)
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change filter", action: changeFilter)
                    
                    Spacer()
                    
                    Image(systemName: "square.and.arrow.up")
                }
            }
            .navigationTitle("InstaFilter")
            .padding([.horizontal, .bottom])
        }
    }
    
    func changeFilter() {
        
    }
}

#Preview {
    ContentView()
}
