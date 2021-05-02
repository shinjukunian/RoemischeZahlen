//
//  Recognizer.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation
import Vision
import AVFoundation

protocol Recognizing:AVCaptureVideoDataOutputSampleBufferDelegate {}

class Recognizer:NSObject, Recognizing, SceneStability, ObservableObject{
    
    @Published var state:SceneStabilityState = .notSteady
    
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
    
    var regionOfInterest = CGRect(x: 0, y: 0, width: 1, height: 1)
    
    override init() {
        super.init()
    }
    
    func recognizeTextHandler(request: VNRequest, error: Error?) {
        var numbers = [String]()
        var redBoxes = [CGRect]() // Shows all recognized text lines
        var greenBoxes = [CGRect]() // Shows words that might be serials
        
        guard let results = request.results as? [VNRecognizedTextObservation] else {
            return
        }
        
        let maximumCandidates = 1
        
        for visionResult in results {
            guard let candidate = visionResult.topCandidates(maximumCandidates).first else { continue }
            
            print(candidate.string)
            
            
//            if let result = candidate.string.extractPhoneNumber() {
//                let (range, number) = result
//                // Number may not cover full visionResult. Extract bounding box
//                // of substring.
//                if let box = try? candidate.boundingBox(for: range)?.boundingBox {
//                    numbers.append(number)
//                    greenBoxes.append(box)
//                    numberIsSubstring = !(range.lowerBound == candidate.string.startIndex && range.upperBound == candidate.string.endIndex)
//                }
//            }
//            if numberIsSubstring {
//                redBoxes.append(visionResult.boundingBox)
//            }
        }
        
        // Log any found numbers.
//        numberTracker.logFrame(strings: numbers)
//        show(boxGroups: [(color: UIColor.red.cgColor, boxes: redBoxes), (color: UIColor.green.cgColor, boxes: greenBoxes)])
//
//        // Check if we have any temporally stable numbers.
//        if let sureNumber = numberTracker.getStableString() {
//            showString(string: sureNumber)
//            numberTracker.reset(string: sureNumber)
//        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        let state=self.assessStability(sampleBuffer: sampleBuffer)
        
        if state == .steady, let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer){
            // Configure for running in real-time.
            request.recognitionLevel = .fast
            // Language correction won't help recognizing phone numbers. It also
            // makes recognition slower.
            request.usesLanguageCorrection = false
            // Only run on the region of interest for maximum speed.
            
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
