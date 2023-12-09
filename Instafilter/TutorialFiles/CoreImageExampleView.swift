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
    
    @State private var sepiaToneAdjustment: Float? = 1.0
    @State private var pixellateAdjustment: Float? = 20.0
    @State private var crystallizeAdjustment: Float? = 100.0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStackView(text: "SwiftUI Image", image: swiftUIImage) {}
                
                VStackView(text: "Sepia Tone", image: sepiaOutputImage, showSliderView: true, sliderValue: $sepiaToneAdjustment, sliderRange: 0...1, sliderStep: 0.05) {
                    sepiaToneImage()
                }
                
                VStackView(text: "Pixellation", image: pixellateOutputImage, showSliderView: true, sliderValue: $pixellateAdjustment, sliderRange: 1...100, sliderStep: 5) {
                    pixellateImage()
                }
                
                VStackView(text: "Crystallize", image: crystallizeOutputImage, showSliderView: true, sliderValue: $crystallizeAdjustment, sliderRange: 1...200, sliderStep: 10) {
                    crystallizeImage()
                }
                
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
        currentFilter.intensity = sepiaToneAdjustment ?? 0
        
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
        currentFilter.scale = pixellateAdjustment ?? 1
        
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
        currentFilter.radius = crystallizeAdjustment ?? 1
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        crystallizeOutputImage = Image(uiImage: uiImage)
    }
}

struct VStackView: View {
    let text: String
    let image: Image?
    let showSliderView: Bool
    let sliderRange: ClosedRange<Float>
    let sliderStep: Float
    
    @Binding var sliderValue: Float?  // Binding to an optional Float
    @State private var internalSliderValue: Float = 0 // Internal state for slider value

    var action: () -> Void
    
    // Computed property to get the effective slider value
    private var effectiveSliderValue: Binding<Float> {
        Binding<Float>(
            get: {
                self.sliderValue ?? self.internalSliderValue
            },
            set: {
                self.sliderValue = $0
                self.internalSliderValue = $0
            }
        )
    }

    init(text: String, image: Image?, showSliderView: Bool = false, sliderValue: Binding<Float?> = .constant(nil), sliderRange: ClosedRange<Float> = 0...1, sliderStep: Float = 1.0, action: @escaping () -> Void) {
        self.text = text
        self.image = image
        self.showSliderView = showSliderView
        self._sliderValue = sliderValue
        self.sliderRange = sliderRange
        self.sliderStep = sliderStep
        self.action = action
    }

    var body: some View {
        VStack {
            Text(text)
                .font(.title)
            image?
                .resizable()
                .scaledToFit()
            if showSliderView {
                Slider(value: effectiveSliderValue, in: sliderRange, step: sliderStep) {_ in 
                    action()
                }
            }
        }
        .padding()
        .border(Color.black)
        .padding(.horizontal)
    }
}


#Preview {
    CoreImageExampleView()
}
