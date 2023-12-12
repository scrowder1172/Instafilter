//
//  PhotoLibraryExample.swift
//  Instafilter
//
//  Created by SCOTT CROWDER on 12/12/23.
//

import SwiftUI
import PhotosUI

struct PhotoLibraryExample: View {
    var body: some View {
        NavigationStack {
            TabView {
                SimplePhotoView()
                    .tabItem {
                        Label("Simple", systemImage: "photo")
                    }
                ComplexPhotoView()
                    .tabItem {
                        Label("Complex", systemImage: "photo.stack")
                    }
            }
        }
        
    }
}

struct SimplePhotoView: View {
    
    @State private var pickerItem: PhotosPickerItem?
    @State private var selectedImage: Image?
    
    var body: some View {
        VStack {
            selectedImage?
                .resizable()
                .scaledToFit()
                .padding()
                .border(Color.black)
                .padding(.horizontal)
            PhotosPicker("Select a picture", selection: $pickerItem, matching: .images)
        }
        .onChange(of: pickerItem) {
            Task {
                selectedImage = try await pickerItem?.loadTransferable(type: Image.self)
            }
        }
        .navigationTitle("Single Picture View")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ComplexPhotoView: View {
    
    @State private var pickerItems: [PhotosPickerItem] = [PhotosPickerItem]()
    @State private var selectedImages: [Image] = [Image]()
    
    var body: some View {
        VStack {
            
            ScrollView {
                ForEach(0..<selectedImages.count, id:\.self) { i in
                    selectedImages[i]
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .border(Color.black)
                        .padding(.horizontal)
                    
                }
            }
        }
        .onChange(of: pickerItems) {
            Task {
                
                selectedImages.removeAll()
                
                for item in pickerItems {
                    if let loadImage = try await item.loadTransferable(type: Image.self) {
                        selectedImages.append(loadImage)
                    }
                }
            }
            
        }
        .navigationTitle("Multiple Picture View")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            PhotosPicker(selection: $pickerItems, maxSelectionCount: 3, matching: .any(of: [.images, .not(.screenshots)])) {
                Label("Select 3 pictures", systemImage: "photo.stack")
            }
        }
    }
}

#Preview {
    PhotoLibraryExample()
}
