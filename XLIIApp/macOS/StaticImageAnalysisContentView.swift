//
//  StaticImageAnalysisView.swift
//  XLII (macOS)
//
//  Created by Morten Bertz on 2022/03/07.
//

import Foundation
import SwiftUI
import AppKit
import XLIICore

struct StaticImageAnalysisContentView:NSViewRepresentable{
    
    typealias NSViewType = NSScrollView
    
    class Coordinator{
        let contentView:StaticImageAnalysisOverlayView
        
        
        init(selection:Binding<Recognizer.TextElement?>, output:Output, convert:Bool){
            contentView=StaticImageAnalysisOverlayView(selection: selection, output: output, convert: convert)
        }
    }
   
    
    @Binding var selectedElement:Recognizer.TextElement?
    let elements:[Recognizer.TextElement]
    let output:Output
    let image:NSImage
    let convert:Bool
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasHorizontalScroller=true
        scrollView.hasVerticalScroller=true
        scrollView.allowsMagnification=true
        scrollView.maxMagnification=4
        scrollView.minMagnification=0.98
        scrollView.backgroundColor = .clear
        scrollView.drawsBackground=false
        scrollView.documentCursor = .arrow
        
        
        let clipView = NSClipView()
        clipView.translatesAutoresizingMaskIntoConstraints = false
        clipView.backgroundColor = .clear
        clipView.drawsBackground=false
        scrollView.contentView = clipView
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: clipView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: clipView.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: clipView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: clipView.bottomAnchor)
            
        ])
        
    
        let documentView = NSImageView()
        documentView.image=image
        documentView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.documentView = documentView
        
        
        clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .left, relatedBy: .equal, toItem: documentView, attribute: .left, multiplier: 1.0, constant: 0))
        clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .top, relatedBy: .equal, toItem: documentView, attribute: .top, multiplier: 1.0, constant: 0))
        clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .right, relatedBy: .equal, toItem: documentView, attribute: .right, multiplier: 1.0, constant: 0))
        clipView.addConstraint(NSLayoutConstraint(item: clipView, attribute: .bottom, relatedBy: .equal, toItem: documentView, attribute: .bottom, multiplier: 1.0, constant: 0))
        NSLayoutConstraint.activate([
            clipView.centerXAnchor.constraint(equalTo: documentView.centerXAnchor),
            clipView.centerYAnchor.constraint(equalTo: documentView.centerYAnchor),
            documentView.widthAnchor.constraint(lessThanOrEqualToConstant: 600),
            documentView.heightAnchor.constraint(lessThanOrEqualToConstant: 600)
        ])
        
        let frame=documentView.imageRect()
        let overlay=context.coordinator.contentView
        overlay.frame=frame
        documentView.addSubview(overlay)
        
        overlay.frame=frame
        overlay.autoresizingMask = [.height, .width]
       
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        guard let doc=nsView.documentView as? NSImageView else{
            return
        }
        let overlay=context.coordinator.contentView
        overlay.elements=elements
        overlay.frame=doc.imageRect()
        overlay.output=output
        overlay.convert=convert
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(selection: $selectedElement, output: output, convert: convert)
    }
    
    
}


class StaticImageAnalysisOverlayView:NSView{
    
    @Invalidating(.display) var elements = [Recognizer.TextElement]()
    @Binding var selectedElement:Recognizer.TextElement?
    @Invalidating(.display) var output:Output = .japanisch
    @Invalidating(.display) var convert:Bool = false
    
    
    init(selection: Binding<Recognizer.TextElement?>, output:Output, convert:Bool){
        _selectedElement=selection
        self.output=output
        self.convert=convert
        super.init(frame: .zero)
        let tap=NSClickGestureRecognizer(target: self, action: #selector(tapped(_:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func tapped(_ sender:NSClickGestureRecognizer){
        let loc=sender.location(in: self)
        let unitLocation=CGPoint(x: loc.x / self.bounds.width, y: loc.y / self.bounds.height)
        guard let element=elements.first(where: {$0.rect.contains(unitLocation)})
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
        guard let scroll=self.enclosingScrollView else{
            return
        }
        switch element.type{
        case .arabicNumber(let number), .romanNumeral(let number), .japaneseNumber(let number):
            let conversion=CameraConversionView(input: number, output: output, original: element.text)
            let hosting=NSHostingController(rootView: conversion)
            let pop=NSPopover()
            pop.behavior = .transient
            pop.contentViewController=hosting
            let scale=CGAffineTransform.init(scaleX: self.bounds.width, y: self.bounds.height)
            let rect=element.rect.applying(scale)
            let converted=scroll.convert(rect, from: self)
            pop.show(relativeTo: converted, of: scroll, preferredEdge: .maxY)
        default: break
        }
        
    }
    
    
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let ctx=NSGraphicsContext.current?.cgContext else{
            return
        }
        self.removeAllToolTips()
        ctx.setFillColor(NSColor.blue.withAlphaComponent(0.2).cgColor)
        ctx.setStrokeColor(NSColor.red.cgColor)
        let width=self.bounds.width
        let height=self.bounds.height
        let scale=CGAffineTransform.init(scaleX: width, y: height)
        for element in elements {
            let converted=element.rect.applying(scale)
            self.addToolTip(converted, owner: element.text, userData: nil)
            if element.type.isNumber, convert, let text=element.convert(output: output){
                let att=NSAttributedString(string: text, attributes: [.font:NSFont.systemFont(ofSize: converted.height)])
                let size=att.size()
                let deltaX=converted.width - size.width
                let deltaY=converted.height - size.height
                let rect=CGRect(origin: converted.origin, size: size).insetBy(dx: -2, dy: -2).offsetBy(dx: deltaX, dy: deltaY)
                ctx.setFillColor(NSColor.white.withAlphaComponent(0.8).cgColor)
                ctx.fill(rect)
                att.draw(at: rect.offsetBy(dx: 2, dy: 2).origin)
            }
            else{
                if element.type.isNumber{
                    ctx.setStrokeColor(NSColor.systemRed.cgColor)
                }
                else{
                    ctx.setStrokeColor(NSColor.systemGray.cgColor)
                }
                ctx.stroke(converted)
            }
            
        }
        
    }
    
    
}

