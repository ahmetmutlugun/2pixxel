import SwiftUI
import PhotosUI

struct ContentView: View {

    @State private var image = UIImage()
    @State private var image2x = UIImage()
    
    @State private var showSheet = false
    @State private var hoveringText = false
    @State private var hoveringImage = true
    @State private var imageTooLarge = false
    
    var body: some View {
        VStack {
            
            Spacer()
            VStack{
                Text("Scale 2x").bold().font(.largeTitle).padding()
                Spacer()
                Image(uiImage: self.image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .background(Color.black.opacity(0.2))
                    .scaledToFill()
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(30)
                    .opacity(hoveringImage ?  0.9 : 1)
                    .onHover { h in
                        hoveringImage = h
                    }
                    .onTapGesture {
                        showSheet = true
                    }.overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1)
                    ).padding(.horizontal, 20)
                Spacer()
                Text("V").bold().font(.largeTitle)
                
                Spacer()
                Image(uiImage: self.image2x)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .background(Color.black.opacity(0.2))
                    .scaledToFill()
                    .aspectRatio(1.0, contentMode: .fit)
                    .cornerRadius(30)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white, lineWidth: 1)
                    ).padding(.horizontal, 20)
                Spacer()
            }
            Spacer()
            Text("Change photo")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 146/255, green: 220/255, blue: 229/255), Color(red: 82/255, green: 222/255, blue: 229/255)]), startPoint: .top, endPoint: .bottom))
                .hoverEffect(.automatic)
                .cornerRadius(15)
                .opacity(hoveringText ?  0.9: 1)
                .foregroundColor(.white)
                .padding(20)
                .onTapGesture {
                    showSheet = true
                }.onHover { h in
                    hoveringText = h
                }
            Spacer()
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet, onDismiss: startScale2x) {
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
        }.background(Color(red: 238/255, green: 229/255, blue: 233/255))
    }
    
    func startScale2x(){
        let upscaledImage = initScale2x(image: image)
        if upscaledImage == image{
            imageTooLarge = true
        }else{
            image2x = upscaledImage
            imageTooLarge = false
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
