//
//  Recognizer.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation
import Vision
import AVFoundation
import CoreImage
import SwiftUI
import XLIICore

protocol Recognizing:AVCaptureVideoDataOutputSampleBufferDelegate {
    var videoAspectRatio: CGFloat {get set}
    var textOrientation: CGImagePropertyOrientation {get set}
}

class Recognizer:NSObject, Recognizing, SceneStability, ObservableObject{
    
    
    
    static let fullAreaROI:CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
    
    @Published var state:SceneStabilityState = .notSteady
    @Published var videoAspectRatio:CGFloat=1
    @Published var foundElements = [TextElement]()
    
    var regionOfInterest = Recognizer.fullAreaROI
    
    lazy var ciContext:CIContext={
        guard let device=MTLCreateSystemDefaultDevice() else{fatalError()}
        let ctx=CIContext(mtlDevice: device)
        return ctx
    }()
    
    lazy var sequenceRequestHandler = VNSequenceRequestHandler()
    lazy var request: VNRecognizeTextRequest = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
    internal var transpositionHistoryPoints: [CGPoint] = [ ]
    var previousPixelBuffer: CVPixelBuffer?
    
    var textOrientation = CGImagePropertyOrientation.up
       
    var currentlyAnalyzedPixelBuffer: CVPixelBuffer?
    var currentFrame=0
    
    @Published var useROI:Bool = true{
        didSet{
            if useROI {
                self.regionOfInterest = defaultRegionOfInterest
            }
            else{
                self.regionOfInterest = Recognizer.fullAreaROI
            }
        }
    }
    
    var defaultRegionOfInterest:CGRect{
        switch self.textOrientation {
        case .left, .right:
            return CGRect(x: 0.25, y: 0.8, width: 0.5, height: 0.1)
        default:
            return CGRect(x: 0.15, y: 0.7, width: 0.7, height: 0.2)
        }
    }
    
    override init() {
        super.init()
        request.recognitionLevel = .fast
        request.usesLanguageCorrection = false
//        request.recognitionLanguages=["zh-Hant", "en"]
        self.useROI = useROI
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let maximumCandidates = 1
        
        var elements=[TextElement]()
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            
            
            candidate.string.enumerateSubstrings(in: candidate.string.startIndex..<candidate.string.endIndex, options: [.byWords], {s, r1, _, _ in
                guard let rect=try? candidate.boundingBox(for: r1)?.boundingBox,
                      let text=s else{
                    return
                }
                if self.useROI{
                    let convertedX=self.regionOfInterest.minX+self.regionOfInterest.width*rect.minX
                    let convertedY=self.regionOfInterest.minY+self.regionOfInterest.height*rect.minY
                    let convertedWidth=self.regionOfInterest.width * rect.width
                    let convertedHeight=self.regionOfInterest.height * rect.height
                    let convertedRect=CGRect(x: convertedX, y: convertedY, width: convertedWidth, height: convertedHeight)
                    elements.append(TextElement(text: text, rect: convertedRect))
                }
                else{
                    elements.append(TextElement(text: text, rect: rect))
                }
                
            })
            
        }
        DispatchQueue.main.async {
            self.foundElements=elements
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let state=self.assessStability(sampleBuffer: sampleBuffer)
        
        if state == .steady, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
            
            request.regionOfInterest = regionOfInterest
            
            let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: textOrientation, options: [.ciContext:self.ciContext])
            do {
                try requestHandler.perform([request])
            } catch {
                print(error)
            }
        }
        
        DispatchQueue.main.async {
            self.state=state
        }
    }
}
