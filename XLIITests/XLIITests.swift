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

    func testBabylonisch(){
        let formatter=ExotischeZahlenFormatter()
        let number=5
        let babylonian=formatter.macheBabylonischeZahl(aus: number)
        XCTAssert(babylonian == "𒐙")
    }
    
    func testSuzhou(){
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
        
        
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
