import UIKit

public class ImageProcessor {
    
    func imageBlock(image: UIImage) -> [Float] {
        
        guard let cgImage = image.cgImage else {
            return []
        }
        
        let pixelData = cgImage.dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let width = cgImage.width
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        var inputData: [Int] = []
        for y in 0..<cgImage.height {
            for x in 0..<cgImage.width {
                let pixelIndex = ((width * y) + x) * bytesPerPixel
                let r = CGFloat(data[pixelIndex]) / CGFloat(255.0)
                _ = CGFloat(data[pixelIndex+1]) / CGFloat(255.0)
                _ = CGFloat(data[pixelIndex+2]) / CGFloat(255.0)
                _ = CGFloat(data[pixelIndex+3]) / CGFloat(255.0)
                if r == 1 {
                    inputData.append(1)
                } else {
                    inputData.append(0)
                }
            }
        }
        
        return inputData.map { Float($0) }
    }
    
    func resize(image: UIImage) -> UIImage? {
        
        let mass = centerOf(image: image)
        
        let target = CGSize(width: 8, height: 8)
        
        let scale = max(target.width / mass.width, target.height / mass.height)
        let scaledSize = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        
        var rect = CGRect(origin: CGPoint(x: -mass.minX * scale, y: -mass.minY * scale), size: scaledSize)
        
        UIGraphicsBeginImageContextWithOptions(target, false, 1)
        defer {
            UIGraphicsEndImageContext()
        }
        
        image.draw(in: rect)
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    func centerOf(image: UIImage) -> CGRect {
        let width = Int(image.size.width)
        let height = Int(image.size.height)
        let midpoint = CGRect(origin: CGPoint.zero, size: image.size)
        
        guard let data = bytes(image: image) else { return midpoint }
        
        var mass: CGFloat = 0
        var rx: CGFloat = 0
        var ry: CGFloat = 0
        var minPoint = CGPoint(x: Int.max, y: Int.max)
        var maxPoint = CGPoint(x: Int.min, y: Int.min)
        
        for row in 0..<height {
            for col in 0..<width {
                let px = 1 - CGFloat(data[row * width + col]) / 255
                guard px > 0 else { continue }
                
                let x = CGFloat(col)
                let y = CGFloat(row)
                
                mass += px
                rx += px * x
                ry += px * y
                
                if x < minPoint.x {
                    minPoint.x = x
                }
                if x > maxPoint.x {
                    maxPoint.x = x
                }
                if y < minPoint.y {
                    minPoint.y = y
                }
                if y > maxPoint.y {
                    maxPoint.y = y
                }
            }
        }
        
        guard mass > 0 else { return midpoint }
        
        let center = CGPoint(x: rx / mass, y: ry / mass)
        
        let hx = max(center.x - minPoint.x, maxPoint.x - center.x)
        let hy = max(center.y - minPoint.y, maxPoint.y - center.y)
        let hh = max(hx, hy)
        
        return CGRect(origin: center, size: CGSize.zero).insetBy(dx: -hh, dy: -hh)
    }
    
    func bytes(image: UIImage) -> Data? {
        let colorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo()
        
        guard let context = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: Int(image.size.width), space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else { return nil }
        
        context.draw(image.cgImage!, in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let data = Data(bytes: context.data!, count: Int(image.size.width * image.size.height))
        
        return data
    }

}
