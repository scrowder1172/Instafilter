//
//  CoreImageExampleView.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/8/23.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CoreImageExampleView: View {
    
    @State private var swiftUIImage: Image?
    @State private var sepiaOutputImage: Image?
    @State private var pixellateOutputImage: Image?
    @State private var crystallizeOutputImage: Image?
    
    @State private var sepiaToneAdjustment: Float = 1.0
    @State private var pixellateAdjustment: Float = 20.0
    @State private var crystallizeAdjustment: Float = 100.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("SwiftUI Image")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    swiftUIImage?
                        .resizable()
                        .scaledToFit()
                }
                .padding()
                .border(.black)
                .padding(.horizontal)
                
                VStack {
                    Text("Sepia Tone")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    sepiaOutputImage?
                        .resizable()
                        .scaledToFit()
                    Slider(value: $sepiaToneAdjustment, in: 0...1, step: 0.05) {_ in
                        sepiaToneImage()
                    }
                }
                .padding()
                .border(.black)
                .padding(.horizontal)
                
                VStack {
                    Text("Pixellation")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    pixellateOutputImage?
                        .resizable()
                        .scaledToFit()
                    Slider(value: $pixellateAdjustment, in: 1...100, step: 5) {_ in
                        pixellateImage()
                    }
                }
                .padding()
                .border(.black)
                .padding(.horizontal)
                
                VStack {
                    Text("Crystallize")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    crystallizeOutputImage?
                        .resizable()
                        .scaledToFit()
                    Slider(value: $crystallizeAdjustment, in: 1...200, step: 10) {_ in
                        crystallizeImage()
                    }
                }
                .padding()
                .border(.black)
                .padding(.horizontal)
                
            }
            .onAppear(perform: {
                loadSwiftUIImage()
                sepiaToneImage()
                pixellateImage()
                crystallizeImage()
                
            })
            .navigationTitle("Swift Image Examples")
        }
        
    }
    
    func loadSwiftUIImage() {
        swiftUIImage = Image(.example)
    }
    
    func sepiaToneImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context: CIContext = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        
        currentFilter.inputImage = beginImage
        currentFilter.intensity = sepiaToneAdjustment
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        sepiaOutputImage = Image(uiImage: uiImage)
    }
    
    func pixellateImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context: CIContext = CIContext()
        let currentFilter = CIFilter.pixellate()
        
        currentFilter.inputImage = beginImage
        currentFilter.scale = pixellateAdjustment
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        pixellateOutputImage = Image(uiImage: uiImage)
    }
    
    func crystallizeImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context: CIContext = CIContext()
        let currentFilter = CIFilter.crystallize()
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = crystallizeAdjustment
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        crystallizeOutputImage = Image(uiImage: uiImage)
    }
}

#Preview {
    CoreImageExampleView()
}
