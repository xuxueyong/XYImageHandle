//
//  UIImage+compress.swift
//
//  Created by Xuxueyong on 2019/1/11.
//  Copyright © 2019 Xuxueyong. All rights reserved.
//

import UIKit

extension UIImage {
    
    /// 压缩图片质量
    ///
    /// - Parameter quality: 压缩质量 0~1 数字越小，图片质量越低
    /// - Returns: 压缩后的图片
    public func compress(quality value: CGFloat) -> UIImage? {
        guard let data = self.jpegData(compressionQuality: value) else {
            return nil
        }
        return UIImage(data: data)
    }
    
    /// 压缩图片尺寸
    ///
    /// - Parameter size: 给定 压缩的 size
    /// - Returns: 压缩后的图片
    public func compress(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        draw(in: CGRect(origin: CGPoint.zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 压缩图片质量， 达到压缩指定大小
    ///   不能保证 压缩到指定大小
    /// - Parameters:
    ///   - maxLength: 指定大小  (压缩后的 字节 <= maxLength)
    /// - Returns: 压缩后的图片
    public func compressImageQuality(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = jpegData(compressionQuality: compression),
            data.count > maxLength else {
            return self
        }
        
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        return UIImage(data: data)!
    }
    
    /// 压缩图片尺寸， 达到压缩指定大小
    ///  不能保证 图片清晰
    /// - Parameter maxLength: 指定大小  (压缩后的 字节 <= maxLength)
    /// - Returns: 压缩后的图片
    public func compressImageSize(toByte maxLength: Int) -> UIImage {
        var resultImage: UIImage = self
        guard var data = jpegData(compressionQuality: 1) else {
            return resultImage
        }
        
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = jpegData(compressionQuality: 1)!
        }
        return resultImage
    }
    
    /// 压缩图片尺寸， 达到压缩指定大小
    ///  既能保证清晰度， 又能指定大小
    /// - Parameter maxLength: (压缩后的 字节 <= maxLength)
    /// - Returns: 压缩后的图片
    public func compressImageQualityAndSize(toByte maxLength: Int) -> UIImage {
        var compression: CGFloat = 1
        guard var data = jpegData(compressionQuality: compression),
            data.count > maxLength else {
                return self
        }
        
        // Compress by quality
        var max: CGFloat = 1
        var min: CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min) / 2
            data = jpegData(compressionQuality: compression)!
            if CGFloat(data.count) < CGFloat(maxLength) * 0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        var resultImage: UIImage = UIImage(data: data)!
        if data.count < maxLength {
            return resultImage
        }
        
        // Compress by size
        var lastDataLength: Int = 0
        while data.count > maxLength, data.count != lastDataLength {
            lastDataLength = data.count
            let ratio: CGFloat = CGFloat(maxLength) / CGFloat(data.count)
            let size: CGSize = CGSize(width: Int(resultImage.size.width * sqrt(ratio)),
                                      height: Int(resultImage.size.height * sqrt(ratio)))
            UIGraphicsBeginImageContext(size)
            resultImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            resultImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            data = jpegData(compressionQuality: compression)!
        }
        return resultImage
    }
}

extension UIImage {
    
    /// 保存为 .png 格式文件大小
    public var pngFileSize: String? {
        guard let data = self.pngData() else {
            return nil
        }
        return fileSizeDesc(data)
    }
    
    /// 保存为 .jpg 格式文件大小
    public var jpegFileSize: String? {
        guard let data = self.jpegData(compressionQuality: 1) else {
            return nil
        }
        return fileSizeDesc(data)
    }
    
    fileprivate func fileSizeDesc(_ data: Data) -> String? {
        let typeArray = ["bytes", "KB", "MB", "GB", "TB", "PB",  "EB", "ZB", "YB"]
        
        var index = 0
        var dataLength = Double(data.count)
        while dataLength > 1024 {
            dataLength /= 1024.0
            index += 1
        }
        
        if index < typeArray.count {
            return "\(dataLength) \(typeArray[index])"
        }
        return nil
    }
}
