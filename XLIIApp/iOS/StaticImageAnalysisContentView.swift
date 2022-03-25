//
//  StaticImageAnalysisView.swift
//  XLII (macOS)
//
//  Created by Morten Bertz on 2022/03/07.
//

import Foundation
import SwiftUI
import AMPopTip
import XLIICore

struct StaticImageAnalysisContentView:UIViewRepresentable{
    
    typealias UIViewType = UIScrollView
    
    class Coordinator:NSObject, UIScrollViewDelegate{
        let contentView:StaticImageAnalysisOverlayView
        let imageView=UIImageView()
        
        init(selection:Binding<Recognizer.TextElement?>, output:Output, convert:Bool){
            contentView=StaticImageAnalysisOverlayView(selection: selection, output: output, convert: convert)
            imageView.contentMode = .scaleAspectFit
        }
        
        func viewForZooming(in scrollView: UIScrollView) -> UIView? {
            return imageView
        }
    }
   
    
    @Binding var selectedElement:Recognizer.TextElement?
    let elements:[Recognizer.TextElement]
    let output:Output
    let image:UIImage
    let convert:Bool
    
    
    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
       
        scrollView.maximumZoomScale=4
        scrollView.minimumZoomScale=0.98
      
        let documentView = context.coordinator.imageView
        documentView.image=image
        documentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.addSubview(documentView)
        scrollView.delegate=context.coordinator
        documentView.isUserInteractionEnabled=true
        
        NSLayoutConstraint.activate([
            documentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            documentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            documentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            documentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            documentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            documentView.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor),
            documentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            documentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)
        ])
        
        let frame=documentView.contentFrame
        let overlay=context.coordinator.contentView
        overlay.frame=frame
        documentView.addSubview(overlay)
        
        overlay.frame=frame
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       
        
        return scrollView
    }
    
    func updateUIView(_ nsView: UIScrollView, context: Context) {
        
        let overlay=context.coordinator.contentView
        overlay.elements=elements
        overlay.frame=context.coordinator.imageView.contentFrame
        overlay.output=output
        overlay.convert=convert
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selectedElement, output: output, convert: convert)
    }
    
    
}


class StaticImageAnalysisOverlayView:UIView{
    
    @Invalidating(.display) var elements = [Recognizer.TextElement]()
    
    @Binding var selectedElement:Recognizer.TextElement?
    @Invalidating(.display) var output:Output = .japanisch
    @Invalidating(.display) var convert:Bool = false
    
    init(selection: Binding<Recognizer.TextElement?>, output:Output, convert:Bool){
        _selectedElement=selection
        self.output=output
        self.convert=convert
        super.init(frame: .zero)
        let tap=UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(tap)
        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapped(_ sender:UITapGestureRecognizer){
        let loc=sender.location(in: self)
        let converted=loc.applying(.init(scaleX: 1, y: -1).concatenating(.init(translationX: 0, y: self.bounds.height).concatenating(.init(scaleX: 1/bounds.width, y: 1/bounds.height))))
        
        guard let element=elements.first(where: {$0.rect.contains(converted)})
        else{
            selectedElement = nil
            return
        }
        selectedElement=element
        if element.type.isNumber{
            showPopover(point: loc, element: element)
        }
    }
    
    func showPopover(point:CGPoint, element:Recognizer.TextElement){
        switch element.type{
        case .arabicNumber(let number), .romanNumeral(let number), .japaneseNumber(let number):
            let conversion=CameraConversionView(input: number, output: output, original: element.text)
            let pop=PopTip()
            let rect=CGRect(origin: point, size: CGSize(width: 5, height: 5))
            let host=UIHostingController(rootView: conversion)
            pop.show(customView: host.view, direction: .auto, in: self, from: rect)
        default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx=UIGraphicsGetCurrentContext() else{
            return
        }
        ctx.setFillColor(UIColor.blue.withAlphaComponent(0.2).cgColor)
        ctx.clear(rect)
        
        let width=self.bounds.width
        let height=self.bounds.height
        let scale=CGAffineTransform.init(scaleX: width, y: -height).concatenating(.init(translationX: 0, y: height))
    
        for element in elements {
            let converted=element.rect.applying(scale)
            if element.type.isNumber, convert, let text=element.convert(output: output){
                let att=NSAttributedString(string: text, attributes: [.font:UIFont.systemFont(ofSize: converted.height)])
                let size=att.size()
                let deltaX=converted.width - size.width
                let deltaY=converted.height - size.height
                let rect=CGRect(origin: converted.origin, size: size).insetBy(dx: -2, dy: -2).offsetBy(dx: deltaX, dy: deltaY)
                ctx.setFillColor(UIColor.white.withAlphaComponent(0.8).cgColor)
                ctx.fill(rect)
                att.draw(at: rect.offsetBy(dx: 2, dy: 2).origin)
            }
            else{
                if element.type.isNumber{
                    ctx.setStrokeColor(UIColor.systemRed.cgColor)
                }
                else{
                    ctx.setStrokeColor(UIColor.systemGray.cgColor)
                }
                ctx.stroke(converted)
            }
        }
    }
    
    
    
}
