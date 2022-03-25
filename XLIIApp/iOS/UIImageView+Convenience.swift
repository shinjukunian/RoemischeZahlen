//
//  UIImageView+Convenience.swift
//  KanjiLookup
//
//  Created by Morten Bertz on 2020/07/13.
//  Copyright © 2020 telethon k.k. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

extension UIImageView{
    var contentFrame:CGRect{
        switch self.contentMode {
        case .scaleAspectFit:
            guard let image = self.image else {return CGRect.zero}
            let ratio=min(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaledRect=CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(scaleX: ratio, y: ratio))
            let dx=(self.bounds.width-scaledRect.width)/2
            let dY=(self.bounds.height-scaledRect.height)/2
            let imageRect=CGRect(origin: CGPoint(x: dx, y: dY), size: scaledRect.size)
            return imageRect
        case .scaleAspectFill:
            guard let image = self.image else {return CGRect.zero}
            let ratio=max(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaledRect=CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(scaleX: ratio, y: ratio))
            let dx=(self.bounds.width-scaledRect.width)/2
            let dY=(self.bounds.height-scaledRect.height)/2
            let imageRect=CGRect(origin: CGPoint(x: dx, y: dY), size: scaledRect.size)
            return imageRect
        default:
            return self.bounds
        }
    }
    
    var viewToImageTransform:CGAffineTransform{
        guard let image=self.image else{return .identity}
        switch self.contentMode {
        case .scaleAspectFit:
            let ratio=min(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaledRect=CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(scaleX: ratio, y: ratio))
            let dx=(self.bounds.width-scaledRect.width)/2
            let dy=(self.bounds.height-scaledRect.height)/2
            let offsetTransform=CGAffineTransform(translationX: -dx, y: -dy)
            let scaleTransform=CGAffineTransform(scaleX: 1/ratio, y: 1/ratio)
            return offsetTransform.concatenating(scaleTransform)
        case .scaleAspectFill:
            let ratio=max(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaledRect=CGRect(origin: .zero, size: image.size).applying(CGAffineTransform(scaleX: ratio, y: ratio))
            let dx=(self.bounds.width-scaledRect.width)/2
            let dy=(self.bounds.height-scaledRect.height)/2
            let offsetTransform=CGAffineTransform(translationX: -dx, y: -dy)
            let scaleTransform=CGAffineTransform(scaleX: 1/ratio, y: 1/ratio)
            return offsetTransform.concatenating(scaleTransform)
        default:
            fatalError("not implemented")
        }
    }
    
    var viewToImageScaleTransform:CGAffineTransform{
        guard let image=self.image else{return .identity}
        switch self.contentMode {
        case .scaleAspectFit:
            let ratio=min(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaleTransform=CGAffineTransform(scaleX: 1/ratio, y: 1/ratio)
            return scaleTransform
        case .scaleAspectFill:
            let ratio=max(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaleTransform=CGAffineTransform(scaleX: 1/ratio, y: 1/ratio)
            return scaleTransform
        default:
            fatalError("not implemented")
        }
    }
    
    var imageToViewTransform:CGAffineTransform{
        guard let image=self.image else{return .identity}
        let contentFrame=self.contentFrame
        
        switch self.contentMode {
        case .scaleAspectFit:
            let ratio=min(self.bounds.width/image.size.width, self.bounds.height/image.size.height)
            let scaleTransform=CGAffineTransform(scaleX: ratio, y: ratio)
            let offset=CGAffineTransform(translationX: contentFrame.minX, y: contentFrame.minY)
            return scaleTransform.concatenating(offset)
            
        default:
            fatalError("not implemented")
        }
    }
}

extension AVCaptureVideoOrientation {
    init?(deviceOrientation: UIInterfaceOrientation) {
        switch deviceOrientation {
        case .portrait: self = .portrait
        case .portraitUpsideDown: self = .portraitUpsideDown
        case .landscapeLeft: self = .landscapeLeft
        case .landscapeRight: self = .landscapeRight
        default: return nil
        }
    }
}


