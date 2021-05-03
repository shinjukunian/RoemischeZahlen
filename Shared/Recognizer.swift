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

protocol Recognizing:AVCaptureVideoDataOutputSampleBufferDelegate {
    var videoAspectRatio: CGFloat {get set}
    var textOrientation: CGImagePropertyOrientation {get set}
}

class Recognizer:NSObject, Recognizing, SceneStability, ObservableObject{
    
    struct TextElement: Equatable, Identifiable{
        
        enum TextElementType:Equatable {
            case arabicNumber(number:Int)
            case romanNumeral(number:Int)
            case japaneseNumber(number:Int)
            case other
            
            init(text:String) {
                if text.potenzielleRömischeZahl,
                   let römisch=ExotischeZahlenFormatter().macheZahl(römisch: text){
                    self = .romanNumeral(number: römisch)
                }
                else if text.potenzielleJapanischeZahl,
                        let japanisch=ExotischeZahlenFormatter().macheZahl(aus: text){
                    self = .japaneseNumber(number: japanisch)
                }
                else if let number=Int(text){
                    self = .arabicNumber(number: number)
                }
                else{
                    self = .other
                }
            }
        }
        
        typealias ID = CGRect
        
        let rect:CGRect
        let text:String
        let type: TextElementType
        
        var id: CGRect{
            return self.rect
        }
    
        init(text:String, rect:CGRect) {
            self.text=text
            self.rect=rect
            self.type = TextElementType(text: text)
        }
        
        func convert(output:Output)->String?{
            
            switch self.type {
            case .arabicNumber(let number) where output == .japanisch:
                return ExotischeZahlenFormatter().macheJapanischeZahl(aus: number)
            case .arabicNumber(let number) where output == .römisch:
                return ExotischeZahlenFormatter().macheRömischeZahl(aus: number)
            case .japaneseNumber(let number) where output == .arabisch, .romanNumeral(let number) where output == .arabisch:
                return String(number)
            default:
                return nil
            }
        }
    }
    
    @Published var state:SceneStabilityState = .notSteady
    @Published var videoAspectRatio:CGFloat=1
    @Published var foundElements = [TextElement]()
    
    
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
                elements.append(TextElement(text: text, rect: rect))
            })
            
        }
        DispatchQueue.main.async {
            self.foundElements=elements
        }
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
