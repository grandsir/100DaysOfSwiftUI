//
//  ContentView.swift
//  InstaFilter
//
//  Created by Mehmet Atabey on 28.07.2021.
//


import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var filterRadius = 1.0
    @State private var filterScale = 0.5

    
    @State private var showingFilterSheet = false
    @State private var showingImagePicker = false
    @State private var processedImage : UIImage?
    @State private var inputImage: UIImage?
    
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""

    
    @State private var buttonTitle = "Change filter"
    
    @State var currentFilter: CIFilter = CIFilter.sepiaTone()
    
    let context = CIContext()
    
    var body: some View {
        let intensity = Binding<Double> (
            get: {
                self.filterIntensity
            },
            
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        let radius = Binding<Double> (
            get: {
                self.filterRadius
            },
            
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )
        
        let scale = Binding<Double> (
            get: {
                self.filterScale
            },
            
            set: {
                self.filterScale = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle().fill(Color.secondary)
                    
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    }
                    else {
                        Text("Tap to select a picture")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .onTapGesture {
                    self.showingImagePicker = true
                }
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity, in: 0...1)
                        }
                    }
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            Text("Radius")
                            Slider(value: radius, in: 0...100)
                        }
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            Text("Scale")
                            Slider(value: scale, in: 0...200)
                        }
                    }
                }
                
                .padding(.vertical)
                
                HStack {
                    Button(buttonTitle) {
                        showingFilterSheet = true
                    }
                    
                    Spacer()
                    
                    Button("Save") {
                        guard inputImage != nil else {
                            errorMessage(title: "You haven't selected an image", message: "Please select an image")

                            return
                            
                        }
                        guard let processedImage = self.processedImage else {
                            errorMessage(title: "Unknown Error", message: "Please try again")
                            return
                            
                        }
                        let imageSaver = ImageSaver()
                        imageSaver.successHandler = {
                            print("Success!")
                        }
                        imageSaver.errorHandler = {
                            print("oops. \($0.localizedDescription)")
                        }
                        imageSaver.writeToPhotoAlbum(image: processedImage)

                    }
                }
            }
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            })
            .padding([.horizontal, .bottom])
            .navigationBarTitle("InstaFilter")
            
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage)
            }
            
            .actionSheet(isPresented: $showingFilterSheet, content: {
                ActionSheet(title: Text("Select a Filter"), buttons: [
                    .default(Text("Crystallize")) { self.setFilter(CIFilter.crystallize())
                        self.buttonTitle = "Crystallize"
                    },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges())
                        self.buttonTitle = "Edges"

                    },
                    
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur())
                        self.buttonTitle = "Gaussian Blur"
                    },
                    .default(Text("Pixellate")) { self.setFilter(CIFilter.pixellate())
                        self.buttonTitle = "Pixellate"
                    },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone())
                        self.buttonTitle = "Sepia Tone"
                    },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask())
                        self.buttonTitle = "Unsharp Mask"
                    },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette())
                        self.buttonTitle = "Vignette"
                    },
                    .cancel()
                ])
            })

        }
    }
    func loadImage() {
        guard let inputImage = inputImage else {
            return
        }
        image = Image(uiImage: inputImage)
        
        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        print(inputKeys)
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(filterRadius, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(filterScale, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else {
            return
        }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            self.processedImage = uiImage
            image = Image(uiImage: uiImage)
        }
    }
    
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func errorMessage(title: String, message: String) {
        self.alertTitle = title
        self.alertMessage = message
        self.showingAlert = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
