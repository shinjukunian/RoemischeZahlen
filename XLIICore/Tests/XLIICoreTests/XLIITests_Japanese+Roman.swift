//
//  File.swift
//  
//
//  Created by Morten Bertz on 2022/02/23.
//

import Foundation
import XCTest
import XLIICore

class XLIICoreTests_japanese: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    
    func testLarge()throws {
        let cases = [65_063_244:"六千五百六万三千二百四十四", 63_376_323_609_176_263:"六京三千三百七十六兆三千二百三十六億九百十七万六千二百六十三"]
        let formatter=ExotischeZahlenFormatter()
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheJapanischeZahl(aus: c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text)")
            let number=try XCTUnwrap(formatter.macheZahl(aus:c.value))
            XCTAssert(number.locale == .japanese)
            XCTAssert(number.value == c.key, "failed \(text) \(c.key) converted to \(number)")
            let backConverted=try XCTUnwrap(formatter.macheZahl(aus:c.value))
            XCTAssert(backConverted.locale == .japanese)
            XCTAssert(backConverted.value == c.key, "failed \(text) \(c.key) converted to \(backConverted)")
        }
    }
    
    @available(iOS 15.0, *)
    @available(macOS 12.0, *)
    func testJapanese()throws{
        
        let formatter=ExotischeZahlenFormatter()
        let cases=[1:"一",11:"十一",131:"百三十一",5766:"五千七百六十六", 65_063_244:"六千五百六万三千二百四十四"]
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheJapanischeZahl(aus: c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text)")
            let number=try XCTUnwrap(formatter.macheZahl(aus:text))
            XCTAssert(number.locale == .japanese)
            XCTAssert(number.value == c.key, "failed \(text) \(c.key) converted to \(number)")
        }
        
        let numbers=(0..<10000).map({_ in return Int.random(in: 0..<80_000_000_000_000_000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheJapanischeZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h), "\(h) (\(number.formatted()) could not be converted back to a number")
            XCTAssert(arabic.locale == .japanese)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    func testRoman() throws{
        let formatter=ExotischeZahlenFormatter()
        let cases=[1:"I",11:"XI",121:"CXXI",3333:"MMMCCCXXXIII", 49:"XLIX", 2000:"MM", 900:"CM", ]
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheRömischeZahl(aus: c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text)")
            let number=try XCTUnwrap(formatter.macheZahl(aus:text))
            XCTAssert(number.locale == .roman)
            XCTAssert(number.value == c.key, "failed \(text) \(c.key) converted to \(number)")
        }
        
        let numbers=(0..<100).map({_ in return Int.random(in: 0..<3500)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheRömischeZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h), "\(h) (\(number) could not be converted back to a number")
            XCTAssert(arabic.locale == .roman, "locale determined as \(arabic.locale), expected roman [\(arabic)]")
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
        
    }
    
    
    func testGlagolitic() throws{
        let formatter=ExotischeZahlenFormatter()
        let cases=[5:"Ⰴ", 16:"ⰅⰊ", 583:"ⰗⰑⰂ", 1280:"ⰝⰔⰑ", 2018:"ⰞⰇⰊ"]
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheGlagolitischeZahl(aus:c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text)")
            let number=try XCTUnwrap(formatter.macheZahl(aus:text))
            XCTAssert(number.locale == .glagolitic)
            XCTAssert(number.value == c.key, "failed \(text) \(c.key) converted to \(number)")
        }
        
        let numbers=(0..<100).map({_ in return Int.random(in: 0..<3000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheGlagolitischeZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h), "\(h) (\(number) could not be converted back to a number")
            XCTAssert(arabic.locale == .glagolitic, "locale determined as \(arabic.locale), expected roman [\(arabic)]")
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    
    
    
}
