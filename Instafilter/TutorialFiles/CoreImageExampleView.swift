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
    
    struct FilterSettings {
        var amount: Float
        var multiplier: Float
    }
    
    enum DynamicImageOptions: String, CaseIterable, Identifiable {
        case Normal = "Normal"
        case Sepia = "Sepia"
        case Pixellation = "Pixellation"
        case Crystalize = "Crystalize"
        
        var id: Self { self }
    }
    
    /// normal image settings
    @State private var swiftUIImage: Image?
    
    /// sepia image settings
    @State private var sepiaOutputImage: Image?
    @State private var sepiaToneAdjustment: Float? = 1.0
    
    /// pixellated image settings
    @State private var pixellateOutputImage: Image?
    @State private var pixellateAdjustment: Float? = 20.0
    
    /// crystalized image settings
    @State private var crystallizeOutputImage: Image?
    @State private var crystallizeAdjustment: Float? = 100.0
    
    /// dynamic image settings
    @State private var dynamicOutputImage: Image?
    @State private var dynamicAdjustment: Float = 1.0
    @State private var dynamicImageOptionSelected: DynamicImageOptions = .Normal
    @State private var dynamicImageFilterSettings: [DynamicImageOptions: FilterSettings] = [
        .Sepia: FilterSettings(amount: 1.0, multiplier: 1.0),
        .Pixellation: FilterSettings(amount: 20.0, multiplier: 1.0),
        .Crystalize: FilterSettings(amount: 20.0, multiplier: 1.0)
    ]
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStackView(text: "SwiftUI Image", image: swiftUIImage) {}
                
                VStackView(text: "Sepia Tone", image: sepiaOutputImage, showSliderView: true, sliderValue: $sepiaToneAdjustment, sliderRange: 0...1, sliderStep: 0.05) {
                    loadSepiaToneImage()
                }
                
                VStackView(text: "Pixellation", image: pixellateOutputImage, showSliderView: true, sliderValue: $pixellateAdjustment, sliderRange: 1...100, sliderStep: 5) {
                    loadPixellateImage()
                }
                
                VStackView(text: "Crystallize", image: crystallizeOutputImage, showSliderView: true, sliderValue: $crystallizeAdjustment, sliderRange: 1...200, sliderStep: 10) {
                    loadCrystallizeImage()
                }
                
                VStack {
                    Text("Dynamic Adjustments")
                        .font(.title)
                    dynamicOutputImage?
                        .resizable()
                        .scaledToFit()
                    Picker("Image Options", selection: $dynamicImageOptionSelected) {
                        ForEach(DynamicImageOptions.allCases, id:\.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: dynamicImageOptionSelected) {
                        if let settings: FilterSettings = dynamicImageFilterSettings[dynamicImageOptionSelected] {
                            dynamicAdjustment = settings.amount
                        }
                        dynamicImage()
                    }
                    
                    switch dynamicImageOptionSelected {
                    case .Sepia:
                        Slider(value: $dynamicAdjustment, in: 0...1, step: 0.05) {_ in
                            dynamicImage()
                        }
                    case .Pixellation:
                        Slider(value: $dynamicAdjustment, in: 1...100, step: 5) {_ in
                            dynamicImage()
                        }
                    case .Crystalize:
                        Slider(value: $dynamicAdjustment, in: 1...200, step: 10) {_ in
                            dynamicImage()
                        }
                    default:
                        Group {}
                    }
                    
                }
                .padding()
                .border(Color.black)
                .padding(.horizontal)
                
                
            }
            .onAppear(perform: {
                loadSwiftUIImage()
                loadSepiaToneImage()
                loadPixellateImage()
                loadCrystallizeImage()
                dynamicImage()
                
            })
            .navigationTitle("Swift Image Examples")
        }
        
    }
    
    func loadSwiftUIImage() {
        swiftUIImage = Image(.example)
    }
    
    func loadSepiaToneImage() {
        
        // 1. Load the input image as a UIImage.
        let inputImage = UIImage(resource: .example)

        // 2. Convert the input image to a CIImage to process it with Core Image.
        let beginImage = CIImage(image: inputImage)

        // 3. Create an instance of CIContext, which will be used to render the processed image.
        let context: CIContext = CIContext()

        // 4. Create the sepia tone filter. CIFilter.sepiaTone() is a convenience initializer for this filter.
        let currentFilter = CIFilter.sepiaTone()

        // 5. Set the input image of the filter to the CIImage created from the original image.
        currentFilter.inputImage = beginImage

        // 6. Set the intensity of the sepia tone effect. The nil-coalescing operator (??) provides a default value of 0 if sepiaToneAdjustment is nil.
        currentFilter.intensity = sepiaToneAdjustment ?? 0

        // 7. Attempt to get the output CIImage from the filter. If it doesn't exist, exit the function.
        guard let outputImage = currentFilter.outputImage else { return }

        // 8. Use the CIContext to render the output CIImage into a CGImage.
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }

        // 9. Convert the CGImage into a UIImage, which can be used in UIKit.
        let uiImage = UIImage(cgImage: cgImage)

        // 10. Convert the UIImage into a SwiftUI Image, which can be displayed in a SwiftUI view hierarchy.
        sepiaOutputImage = Image(uiImage: uiImage)

    }
    
    func loadPixellateImage() {
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
    
    func loadCrystallizeImage() {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context: CIContext = CIContext()
        let currentFilter = CIFilter.crystallize()
        print("The type for currentFilter is: \(type(of: currentFilter))")
        
        currentFilter.inputImage = beginImage
        currentFilter.radius = crystallizeAdjustment ?? 1
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        
        crystallizeOutputImage = Image(uiImage: uiImage)
    }
    
    func dynamicImage(amount: Float = 1, multiplier: Float = 1) {
        let inputImage = UIImage(resource: .example)
        let beginImage = CIImage(image: inputImage)
        
        let context = CIContext()
        var currentFilter: CIFilter?
        
        if dynamicImageOptionSelected == .Normal {
            dynamicOutputImage = Image(uiImage: inputImage)
        } else {

            print("dynamicImageOptionSelected = \(dynamicImageOptionSelected)")
            switch dynamicImageOptionSelected {
            case .Sepia:
                currentFilter = CIFilter.sepiaTone()
            case .Pixellation:
                currentFilter = CIFilter.pixellate()
            case .Crystalize:
                currentFilter = CIFilter.crystallize()
            default:
                currentFilter = CIFilter.twirlDistortion()
            }
            
            guard let filter = currentFilter else {return}
            
            guard var settings: FilterSettings = dynamicImageFilterSettings[dynamicImageOptionSelected] else {return}
            settings.amount = dynamicAdjustment
            
            
            let adjustedAmount = settings.amount * settings.multiplier

            configureFilter()

            guard let outputImage = filter.outputImage else {return}
            guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else {return}
            let uiImage = UIImage(cgImage: cgImage)
            
            dynamicOutputImage = Image(uiImage: uiImage)
            
            updateFilterSettings(for: dynamicImageOptionSelected, amount: dynamicAdjustment, multiplier: settings.multiplier)
            
            func configureFilter() {
                filter.setValue(beginImage, forKey: kCIInputImageKey)
                let inputKeys = filter.inputKeys

                if inputKeys.contains(kCIInputIntensityKey) {
                    filter.setValue(adjustedAmount, forKey: kCIInputIntensityKey)
                }
                if inputKeys.contains(kCIInputRadiusKey) {
                    filter.setValue(adjustedAmount, forKey: kCIInputRadiusKey)
                }
                if inputKeys.contains(kCIInputScaleKey) {
                    filter.setValue(adjustedAmount, forKey: kCIInputScaleKey)
                }
            }
            
            func updateFilterSettings(for filter: DynamicImageOptions, amount: Float, multiplier: Float) {
                dynamicImageFilterSettings[filter] = FilterSettings(amount: amount, multiplier: multiplier)
            }
        
        }
        
        
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
