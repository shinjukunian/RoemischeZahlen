//
//  PreviewView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/02.
//

import Foundation
import SwiftUI
import AVFoundation

#if canImport(Appkit)
import AppKit
typealias MyView = NSView
#else
import UIKit
typealias MyView = UIView
#endif




#if canImport(AppKit)
struct PreviewHolder: NSViewRepresentable {
    
    let recognizer:Recognizer
    
    init(recognizer:Recognizer) {
        self.recognizer=recognizer
    }
    
    
    func makeNSView(context: NSViewRepresentableContext<PreviewHolder>) -> PreviewView {
        return PreviewView(delegate: self.recognizer)
    }

    func updateNSView(_ uiView: PreviewView, context: NSViewRepresentableContext<PreviewHolder>) {
        
    }

    typealias NSViewType = PreviewView
}

#else
struct PreviewHolder: UIViewRepresentable {

    let recognizer:Recognizer
    
    init(recognizer:Recognizer) {
        self.recognizer=recognizer
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> PreviewView {
        return PreviewView(delegate: recognizer)
    }
    
    
    typealias UIViewType = PreviewView
    
}
#endif


class PreviewView: MyView {
    private var captureSession: AVCaptureSession?
    var videoDataOutput = AVCaptureVideoDataOutput()
    let videoDataOutputQueue = DispatchQueue(label: "com.telethon.VideoDataOutputQueue")

    @Published var bufferAspectRatio:CGFloat = 1
    
    weak var delegate:Recognizing?
    
    init(delegate: Recognizing) {
        self.delegate=delegate
        super.init(frame: .zero)

        var allowedAccess = false
        let blocker = DispatchGroup()
        blocker.enter()
        AVCaptureDevice.requestAccess(for: .video) { flag in
            allowedAccess = flag
            blocker.leave()
        }
        blocker.wait()

        if !allowedAccess {
            print("!!! NO ACCESS TO CAMERA")
            return
        }
        
        self.setupCamera()
        

        // instead of below, use layerClass on iOS
        #if canImport(AppKit)
        self.wantsLayer = true
        self.layer = AVCaptureVideoPreviewLayer()
        #endif
    }
    
    func setupCamera(){
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            print("Could not create capture device.")
            return
        }
        let session = AVCaptureSession()
        session.beginConfiguration()
        
        if videoDevice.supportsSessionPreset(.hd4K3840x2160) {
//            session.sessionPreset = AVCaptureSession.Preset.hd4K3840x2160
            bufferAspectRatio = 3840.0 / 2160.0
        } else if videoDevice.supportsSessionPreset(.hd1920x1080) {
//            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            bufferAspectRatio = 1920.0 / 1080.0
        }
        else if videoDevice.supportsSessionPreset(.hd1280x720){
//            session.sessionPreset = AVCaptureSession.Preset.hd1920x1080
            bufferAspectRatio = 1280.0 / 720.0
        }
        self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: bufferAspectRatio).isActive=true

        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
            session.canAddInput(videoDeviceInput)
            else { return }
        session.addInput(videoDeviceInput)
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]
        videoDataOutput.setSampleBufferDelegate(delegate, queue: videoDataOutputQueue)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
        }
        session.commitConfiguration()
        self.captureSession = session
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }

    override func layout() {
        super.layout()
        
    }
    
    func moveToSuperView(){
        if nil != self.superview {
            self.videoPreviewLayer.session = self.captureSession
            self.videoPreviewLayer.videoGravity = .resizeAspect
            self.captureSession?.startRunning()
        } else {
            self.captureSession?.stopRunning()
        }
    }
    
    #if canImport(AppKit)
    override func viewDidMoveToSuperview() { // on iOS .didMoveToSuperview
        super.viewDidMoveToSuperview()
        self.moveToSuperView()
    }
    
    #else
    override class var layerClass: AnyClass{
        return AVCaptureVideoPreviewLayer.self
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.moveToSuperView()
    }
    
    #endif
    
}
