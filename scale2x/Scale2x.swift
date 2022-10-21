//
//  Scale2x.swift
//  scale2x
//
//  Created by Ahmet on 10/20/22.
//

import Foundation
import UIKit

func scaler2x(image: UIImage) -> UIImage{
    getPixelData(image: image)
    print("Getting pixel data")
    return image
}

func getPixelData(image:UIImage) -> [UInt8]? {
//    var img = image.cgImage!
//    let width = img.width
//    let height = img.height
//
//    let bytesPerPixel = 4
//    let bytesPerRow = bytesPerPixel * width
//    let bitsPerComponent = 8
//
//
    
    let size = image.size
    let dataSize = size.width * size.height * 4
    var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: &pixelData,
                            width: Int(size.width),
                            height: Int(size.height),
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * Int(size.width),
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    guard let cgImage = image.cgImage else { return nil }
    context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    
    var current = [[[UInt8]]]()
    
    var width = Int(size.width)
    var height = Int(size.height)
    
    print("width: \(width)")
    print("height: \(height)")
    print("total: \(pixelData.count)")
    
    for i in stride(from: 0, to: height, by: 1) {
        var current_row: [UInt8] = [UInt8](pixelData[(i*width*4)...i*(width)*4 + width * 4 - 1])
        current.append(current_row.chunked(into: 4))
    }
    
    print(current)
    
    return pixelData
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
