//
//  Scale2x.swift
//  scale2x
//
//  Created by Ahmet on 10/20/22.
//

import Foundation
import UIKit

func initScale2x(image: UIImage) -> UIImage{
    // run your work
    let start = CFAbsoluteTimeGetCurrent()
    let pixelData = getPixelData(image: image)
    if pixelData != nil{
        let img = scale2x(current: pixelData!)
        if img != nil{
            let finalImage = pixelToImage(pixelData: img!)
            if finalImage != nil{
                print("Time spent processing: \(CFAbsoluteTimeGetCurrent()-start)")
                return finalImage!
            }
        }
    }
    
    return image
}

func getPixelData(image: UIImage) -> [[[UInt8]]]? {
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
    
    let width = Int(size.width)
    let height = Int(size.height)
    
    for i in stride(from: 0, to: height, by: 1) {
        let current_row: [UInt8] = [UInt8](pixelData[(i*width*4)...i*(width)*4 + width * 4 - 1])
        current.append(current_row.chunked(into: 4))
    }
    
    return current
}

func scale2x(current:[[[UInt8]]]) -> [[[UInt8]]]? {
    let height = current.count
    let width = current[0].count
    var pixelData = [[[UInt8]]]()
    
    for cols in 0...height-1{
        var row = [[UInt8]]()
        var row2 = [[UInt8]]()
        
        for rows in 0...width-1{
            let up = cols != 0 ? current[cols-1][rows] : current[cols][rows]
            let down = cols < height-1 ? current[cols+1][rows] : current[cols][rows]
            let left = rows != 0 ? current[cols][rows-1] : current[cols][rows]
            let right = rows < width-1 ? current[cols][rows+1] : current[cols][rows]
            
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
        pixelData.append(row)
        pixelData.append(row2)
    }
    return pixelData
    
}

func scale3x(current:[[[UInt8]]]) -> [[[UInt8]]]? {
    //TODO
    return current
}

func pixelToImage(pixelData: [[[UInt8]]]) -> UIImage?{
    let height = pixelData.count
    let width = pixelData[0].count
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    
    var byteArr = Array(pixelData.joined().joined())
    let context2 = CGContext(data: &byteArr,
                            width: width,
                            height: height,
                            bitsPerComponent: 8,
                            bytesPerRow: 4 * width,
                            space: colorSpace,
                            bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)
    if context2 != nil{
        let img = context2?.makeImage()
        let finalImg = UIImage(cgImage: img!)
        return finalImg
    }
    return nil
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
