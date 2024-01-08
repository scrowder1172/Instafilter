//
//  ContentView.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/6/23.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins
import StoreKit

struct ContentView: View {
    
    enum FilterNames: String {
        case sepia = "Sepia Tone"
        case crystalize = "Crystalize"
        case bloom = "Bloom"
        case edges = "Edges"
        case gaussianBlur = "Gaussian Blur"
        case pixellate = "Pixellate"
        case pointillize = "Pointillize"
        case noir = "Noir"
        case unsharpMask = "Unsharp Mask"
        case vignette = "Vignette"
    }
    
    @State private var processedImage: Image?
    @State private var originalImage: Image?
    @State private var filterIntensity: Float = 0.5
    @State private var filterRadius: Float = 3.0
    @State private var filterScale: Float = 5.0
    @State private var selectedItem: PhotosPickerItem?
    
    @State private var showingFilters: Bool = false
    @State private var currentFilterName: String = FilterNames.sepia.rawValue
    
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context: CIContext = CIContext()
    
    @AppStorage("filterCount") var filterCount: Int = 0
    @Environment(\.requestReview) var requestReview
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    VStack {
                        ZStack(alignment: .bottomTrailing) {
                            if let originalImage {
                                originalImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                                    .border(.black)
                                Text("Original Image")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(.black.opacity(0.75))
                                    .clipShape(.capsule)
                                    .offset(x: -20, y: -20)
                            }
                        }
                        
                        
                        if let processedImage {
                            ZStack(alignment: .bottomTrailing) {
                                processedImage
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                                    .border(.black)
                                Text("Updated Image: \(currentFilterName)")
                                    .font(.caption)
                                    .fontWeight(.black)
                                    .padding(8)
                                    .foregroundStyle(.white)
                                    .background(.black.opacity(0.75))
                                    .clipShape(.capsule)
                                    .offset(x: -20, y: -20)
                            }
                        } else {
                            ContentUnavailableView {
                                Label("No Picture", systemImage: "photo.badge.plus")
                            } description: {
                                Text("Tap to import a photo")
                            }
                            .padding()
                            .border(.black)
                        }
                    }
                    
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: $filterIntensity)
                                .onChange(of: filterIntensity, applyImageProcessing)
                        }
                        .padding(.top)
                        .disabled(processedImage == nil)
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(value: $filterRadius, in: 0...200)
                                .onChange(of: filterRadius, applyImageProcessing)
                        }
                        .disabled(processedImage == nil)
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                            Slider(value: $filterScale, in: 0...10)
                                .onChange(of: filterScale, applyImageProcessing)
                        }
                        .padding(.bottom)
                        .disabled(processedImage == nil)
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button("Change filter", action: changeFilter)
                    
                    Spacer()
                    
                    if let processedImage {
                        ShareLink(item: processedImage, preview: SharePreview("InstaFilter Image", image: processedImage))
                    }
                }
                .disabled(processedImage == nil)
            }
            .navigationTitle("InstaFilter")
            .padding([.horizontal, .bottom])
            .confirmationDialog("Change Filter", isPresented: $showingFilters) {
                Button(FilterNames.crystalize.rawValue) {
                    setFilter(CIFilter.crystallize(), filterName: FilterNames.crystalize)
                }
                Button(FilterNames.edges.rawValue) {
                    setFilter(CIFilter.edges(), filterName: FilterNames.edges)
                }
                Button(FilterNames.bloom.rawValue) {
                    setFilter(CIFilter.bloom(), filterName: FilterNames.bloom)
                }
                Button(FilterNames.gaussianBlur.rawValue) {
                    setFilter(CIFilter.gaussianBlur(), filterName: FilterNames.gaussianBlur)
                }
                Button(FilterNames.pixellate.rawValue) {
                    setFilter(CIFilter.pixellate(), filterName: FilterNames.pixellate)
                }
                Button(FilterNames.pointillize.rawValue) {
                    setFilter(CIFilter.pointillize(), filterName: FilterNames.pointillize)
                }
                Button(FilterNames.noir.rawValue) {
                    setFilter(CIFilter.photoEffectNoir(), filterName: FilterNames.noir)
                }
                Button(FilterNames.sepia.rawValue) {
                    setFilter(CIFilter.sepiaTone(), filterName: FilterNames.sepia)
                }
                Button(FilterNames.unsharpMask.rawValue) {
                    setFilter(CIFilter.unsharpMask(), filterName: FilterNames.unsharpMask)
                }
                Button(FilterNames.vignette.rawValue) {
                    setFilter(CIFilter.vignette(), filterName: FilterNames.vignette)
                }
                Button("Cancel", role: .cancel) {}
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else {return}
            guard let inputImage = UIImage(data: imageData) else {return}
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyImageProcessing()
            
            originalImage = Image(uiImage: inputImage)
        }
    }
    
    func applyImageProcessing() {
        if filterIntensity == 0 {
            filterIntensity = 0.0001
        }
        
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    @MainActor func setFilter(_ filter: CIFilter, filterName: FilterNames) {
        currentFilter = filter
        currentFilterName = filterName.rawValue
        loadImage()
        
        filterCount += 1
        if filterCount >= 3 {
            requestReview()
        }
    }
}

#Preview {
    ContentView()
}
