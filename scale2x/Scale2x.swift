//
//  Scale2x.swift
//  scale2x
//
//  Created by Ahmet on 10/20/22.
//

import Foundation
import UIKit

func initScale2x(image: UIImage) -> UIImage{
    let start = CFAbsoluteTimeGetCurrent()
    
    // run your work
    let img = scale2x(image: image)
    let diff = CFAbsoluteTimeGetCurrent() - start
    
    print("Took \(diff) seconds")
    if img != nil{
        return img!
    }
    return image
}

func scale2x(image:UIImage) -> UIImage? {
    
    let size = image.size
    let dataSize = size.width * size.height * 4
    if dataSize > 1000000{
        print("Image is too big!")
        return nil
    }
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
    var new = [[[UInt8]]]()
    
    let width = Int(size.width)
    let height = Int(size.height)
    
//    print("width: \(width)")
//    print("height: \(height)")
//    print("total: \(pixelData.count)")
    
    for i in stride(from: 0, to: height, by: 1) {
        let current_row: [UInt8] = [UInt8](pixelData[(i*width*4)...i*(width)*4 + width * 4 - 1])
        current.append(current_row.chunked(into: 4))
    }
    for cols in 0...height-1{
        var row = [[UInt8]]()
        var row2 = [[UInt8]]()
        
        for rows in 0...width-1{
            var up = current[cols][rows]
            var down = current[cols][rows]
            var left = current[cols][rows]
            var right = current[cols][rows]
            
            if cols != 0{
                up = current[cols-1][rows]
            }
            if cols < height-2{
                down = current[cols+1][rows]
            }
            if rows != 0{
                left = current[cols][rows-1]
            }
            if rows < width-2{
                right = current[cols][rows+1]
            }
            
            var c1 = current[cols][rows]
            var c2 = current[cols][rows]
            var c3 = current[cols][rows]
            var c4 = current[cols][rows]
            
            if (up != down && left != right) {
                c1 = left == up ? left : current[cols][rows]
                c2 = up == right ? right : current[cols][rows]
                c3 = left == down ? left : current[cols][rows]
                c4 = down == right ? right : current[cols][rows]
            }
            row.append(c1)
            row.append(c2)
            row2.append(c3)
            row2.append(c4)
        }
        new.append(row)
        new.append(row2)
    }
    var byteArr = Array(new.joined().joined())
    //let data = NSData(bytes: Array(new.joined().joined()), length: 2)

    let context2 = CGContext(data: &byteArr,
                            width: width * 2,
                            height: height * 2,
                            bitsPerComponent: 8,
                            bytesPerRow: 8 * width,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    if context2 != nil{
        let img = context2?.makeImage()
        let finalImg = UIImage(cgImage: img!)
        return finalImg
    }

    return image
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
