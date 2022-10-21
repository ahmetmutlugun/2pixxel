import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Image(uiImage: self.image)
                .interpolation(.none)
                .resizable()
                .cornerRadius(1)
                .frame(width: 100, height: 100)
                .background(Color.black.opacity(0.2))
                .aspectRatio(contentMode: .fill)
                .clipShape(Circle())
            
            Text("Change photo")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.262745098, green: 0.0862745098, blue: 0.8588235294, alpha: 1)), Color(#colorLiteral(red: 0.5647058824, green: 0.462745098, blue: 0.9058823529, alpha: 1))]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(16)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .onTapGesture {
                    showSheet = true
                }
        }
        .padding(.horizontal, 20)
        .sheet(isPresented: $showSheet, onDismiss: startScale2x) {
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            
            //  If you wish to take a photo from camera instead:
            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
    }
    
    func startScale2x(){
        image = scaler2x(image: image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
