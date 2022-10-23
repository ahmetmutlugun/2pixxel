//
//  OptionSelector.swift
//  scale2x
//
//  Created by Ahmet on 10/22/22.
//

import SwiftUI
import PhotosUI

struct OptionSelector: View {
    @State private var algorithm = "Scale2x"
    @State private var noise = "1"
    
    var body: some View {
        GroupBox(label: Label("Advanced Options", systemImage: "gearshape.fill")){
            HStack{
                Spacer()
                VStack{
                    Text("Algorithm").font(.title3).bold().padding(.top)
                    Menu(algorithm) {
                        Menu("Scale2x") {
                            Button("Scale2x", action: {algorithm = "Scale2x"})
                            Button("Scale3x", action: {algorithm = "Scale3x"})
                        }
                        Button("Fast2x", action: {algorithm = "Fast2x"})
                        VStack{
                            Button("Slow2x", action: {algorithm = "Slow2x"})
                        }
                    }
                }
                Spacer()
                VStack{
                    Text("Noise Reduction").font(.title3).bold().padding(.top)
                    Menu("Reduction: \(noise)") {
                        Button("1", action: {noise = "1"})
                        Button("2", action: {noise = "2"})
                        Button("3", action: {noise = "3"})
                        Button("4", action: {noise = "4"})
                        Text("High noise reduction may reduce quality")
                    }
                }
                Spacer()
            }
        }
    }
}

struct OptionSelector_Previews: PreviewProvider {
    static var previews: some View {
        OptionSelector().previewDevice(PreviewDevice(rawValue: "ifon"))
    }
}
