import SwiftUI
import PhotosUI

struct ContentView: View {

    @State private var image = UIImage()
    @State private var image2x = UIImage()
    @State private var showSheet = false
    @State private var hoveringText = false
    @State private var hoveringImage = true
    @State private var imageTooLarge = false
    @State private var progress = 0.0
    @State private var showingAlert = false
    @State private var showingAlert2 = false
    
    var body: some View {
        VStack {
            VStack{
                Text("Scale 2x").bold().font(.largeTitle).padding(.bottom)
                Text("Click below to select an image, then select upscale.").onTapGesture {
                    showSheet = true
                }
                ZStack{
                    if image.size.width < 1{
                        Image(systemName: "photo.fill").imageScale(.large)
                    }
                    Image(uiImage: self.image)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(alignment: .center)
                        .scaledToFit()
                        .cornerRadius(30)
                        .opacity(hoveringImage ?  0.9 : 1)
                        .onHover { h in
                            hoveringImage = h
                        }
                        .onTapGesture {
                            showSheet = true
                        }.overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(red: 113/255, green: 128/255, blue: 172/255), lineWidth: 1)

                        ).padding(.horizontal, 20)
                }
                
                if image2x.size.width > 0{
                    Image(systemName: "arrow.down").scaleEffect(2.0).padding(3)
                }
                if image2x.size.width > 0{
                    Image(uiImage: self.image2x)
                        .interpolation(.none)
                        .resizable()
                        .scaledToFit()
                        .frame(alignment: .center)
                        .scaledToFit()
                        .cornerRadius(30)
                        .opacity(hoveringImage ?  0.9 : 1)
                        .onHover { h in
                            hoveringImage = h
                        }.overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color(red: 113/255, green: 128/255, blue: 172/255), lineWidth: 1)

                        ).padding(.horizontal, 20)
                }
                
                Spacer()
            }
            Spacer()
            Text("Upscale")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 43/255, green: 69/255, blue: 229/255), Color(red: 42/255, green: 69/255, blue: 229/255)]), startPoint: .top, endPoint: .bottom))
                .hoverEffect(.automatic)
                .cornerRadius(22)
                .opacity(hoveringText ?  0.9: 1)
                .foregroundColor(.white)
                .onTapGesture {
                    startScale2x()
                }.onHover { h in
                    hoveringText = h
                }.alert("Image too large!", isPresented: $showingAlert) {
                    Button("OK") {}
                }message: {
                    Text("Images larger than 500x500 are not yet supported. Please pick a smaller image or use the resize option.")
                }.alert("Image not picked!", isPresented: $showingAlert2) {
                    Button("OK") {}
                }message: {
                    Text("Please pick an image above.")
                }.padding()
            OptionSelector()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet, onDismiss: resetImage2x) {
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }.background(Color(red: 255/255, green: 255/255, blue: 255/255))
    }
    
    func resetImage2x(){
        image2x = UIImage()
    }
    
    func startScale2x(){
        if image.size.width < 1{
            showingAlert2 = true
            return
        }
        progress = 0.0
        // run your work
        let start = CFAbsoluteTimeGetCurrent()
        
        if image.size.width * image.size.height * 4 > 1000000{
            imageTooLarge = true
            progress = 1
            showingAlert = true
            return
        }
        
        let pixelData = getPixelData(image: image)
        progress = 0.1
        if pixelData != nil{
            progress = 0.2
            imageTooLarge = false
                
            let img = scale2x(current: pixelData!)
            if img != nil{
                progress = 0.9
                let finalImage = pixelToImage(pixelData: img!)
                if finalImage != nil{
                    progress = 1
                    print("Time spent processing: \(CFAbsoluteTimeGetCurrent()-start)")
                    image2x = finalImage!
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().previewDevice(PreviewDevice(rawValue: "ifon"))
    }
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
