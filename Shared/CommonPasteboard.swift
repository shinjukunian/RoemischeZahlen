//
//  CommonPasteboard.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/25.
//

import Foundation

#if os(macOS)
import AppKit
typealias Pasteboard = NSPasteboard
#else
import UIKit
typealias Pasteboard = UIPasteboard
#endif


extension Pasteboard{
    func add(text:String){
#if os(macOS)
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(text, forType: .string)
#else
        UIPasteboard.general.string=text
#endif
    }
}
