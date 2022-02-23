//
//  XLIITests.swift
//  XLIITests
//
//  Created by Morten Bertz on 2022/02/21.
//

import XCTest
@testable import XLII

class XLIITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBabylonisch()throws {
        let formatter=ExotischeZahlenFormatter()
        let cases : [Int:String] = [1:"𒐕",
                                    11:"𒌋𒐕",
                                    25:"《𒐙",
                                    50:"𒐐␣",
                                    99:"𒐕 𒌍𒐝",
                                    111:"𒐕 𒐐𒐕",
                                    511:"𒐜 𒌍𒐕",
                                    2018:"𒌍𒐗 𒌍𒐜",
                                    123321:"𒌍𒐘 𒌋𒐙 《𒐕",
                                    4711:"𒐕 𒌋𒐜 𒌍𒐕",
                                    99999:"《𒐛 𒐏𒐚 𒌍𒐝",
                                    455678:"𒐖 𒐚 𒌍𒐘 𒌍𒐜",
                                    60: "𒐕 ␣",
                                    59: "𒐐𒐝",
                                    602: "𒌋␣ 𒐖",
                                    610: "𒌋␣ 𒌋␣",
                                    1234321:"𒐙 𒐏𒐖 𒐐𒐖 𒐕",
                                    9876543210:"𒌋𒐖 𒐏𒐖 𒐘 𒐏𒐘 𒌋𒐗 𒌍␣"
        ]
        
        
        
        for c in cases{
            let text=try XCTUnwrap(formatter.macheBabylonischeZahl(aus: c.key))
            XCTAssert(text == c.value, "failed \(c.key) \(c.value) converted to \(text )")
        }
        
    }
    
    func testSuzhou() throws {
        //https://codegolf.stackexchange.com/questions/177517/convert-to-suzhou-numerals
        let cases : [Int:String] = [1:"〡",
                                    11:"〡一",
                                    25:"〢〥",
                                    50:"〥〇",
                                    99:"〩〩",
                                    111:"〡一〡",
                                    511:"〥〡一",
                                    2018:"〢〇〡〨",
                                    123321:"〡二〣三〢一",
                                    1234321:"〡二〣〤〣二〡",
                                    9876543210:"〩〨〧〦〥〤〣二〡〇"]
        let formatter=ExotischeZahlenFormatter()
        
        for c in cases{
            let text=formatter.macheSuzhouZahl(aus: c.key)
            XCTAssert(text == c.value)
        }
        
        for c in cases{
            let number=try XCTUnwrap(formatter.macheZahl(aus: c.value))
            XCTAssert(number.locale == .suzhou)
            XCTAssert(number.value == c.key)
            
        }
        
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<100_000_000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheSuzhouZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h))
            XCTAssert(arabic.locale == .suzhou)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
        
        
    }
    
    
    func testHieroglyphs() throws{
        let formatter=ExotischeZahlenFormatter()
        let cases = [42:"𓎉𓏻", 4242:"𓆿𓍣𓎉𓏻", 2_222_222:"𓁨𓁨𓆐𓆐𓂮𓆽𓍣𓎇𓏻"]
        for c in cases{
            let text=try XCTUnwrap(formatter.macheHieroglyphenZahl(aus: c.key))
            XCTAssert(text == c.value)
            let number=try XCTUnwrap(formatter.macheZahl(aus: text))
            XCTAssert(number.locale == .hieroglyph)
            XCTAssert(number.value == c.key)
        }
        
        for c in cases.merging([203:"𓍢𓍢𓏺𓏺𓏺", 113:"𓍢𓎆𓏺𓏺𓏺", 99:"𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓏺𓏺𓏺𓏺𓏺𓏺𓏺𓏺𓏺", 12587:"𓂭𓆼𓆼𓍢𓍢𓍢𓍢𓍢𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓎆𓏺𓏺𓏺𓏺𓏺𓏺𓏺"], uniquingKeysWith: {s1,_ in return s1}){
            let number=try XCTUnwrap(formatter.macheZahl(aus: c.value))
            XCTAssert(number.locale == .hieroglyph)
            XCTAssert(number.value == c.key)

        }
        
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<10_000_000)})
        
        for number in numbers{
            let h=try XCTUnwrap(formatter.macheHieroglyphenZahl(aus: number))
            XCTAssert(h.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: h))
            XCTAssert(arabic.locale == .hieroglyph)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    func testAegean()throws{
        let formatter=ExotischeZahlenFormatter()
        let numbers=(0..<1000).map({_ in return Int.random(in: 0..<100_000)})
        for number in numbers{
            let aegean=try XCTUnwrap(formatter.macheAegaeischeZahl(aus: number))
            XCTAssert(aegean.isEmpty == false)
            let arabic=try XCTUnwrap(formatter.macheZahl(aus: aegean))
            XCTAssert(arabic.locale == .aegean)
            XCTAssert(arabic.value == number, "failed \(number) converted to \(arabic.value)")
        }
    }
    
    func testPhoenician()throws{
        let numbers=[1:"𐤖",
                2:"𐤚",
                     3:"𐤛",
                     9:"𐤛𐤛𐤛",
                     19:"𐤗𐤛𐤛𐤛",
                     20:"𐤘",
                     30:"𐤘𐤗",
                     60:"𐤘𐤘𐤘",
                     143:"𐤙𐤘𐤘𐤛",
                     340:"𐤛𐤙𐤘𐤘",
                     900:"𐤛𐤛𐤛𐤙"
        ]
        for number in numbers{
            let p=try XCTUnwrap( PhoenizianFormatter(number: number.key) )
            XCTAssert(p.phoenician == number.value, "\(number.key) converted to \(p.phoenician), expected \(number.value)")
            let reverse=try XCTUnwrap(PhoenizianFormatter(string: p.phoenician))
            XCTAssert(reverse.arabic == number.key, "\(p.phoenician) converted to \(reverse.arabic), expected \(number.key)")
        }
        
        XCTAssertNil(PhoenizianFormatter(string: "hallo"))
        XCTAssertNil(PhoenizianFormatter(number: 1000))
        XCTAssertNotNil(PhoenizianFormatter(string: "𐤗𐤛𐤛𐤛"))
        
        let random=(0..<1000).map({_ in return Int.random(in: 0..<1_000)})
        
        for number in random{
            let p=try XCTUnwrap( PhoenizianFormatter(number: number) )
            let reverse=try XCTUnwrap(PhoenizianFormatter(string: p.phoenician))
            
            XCTAssert(reverse.arabic == number, "\(p.phoenician) converted to \(reverse.arabic), expected \(number)")
        }
        
        
    }


}

