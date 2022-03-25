//
//  XLIITests.swift
//  XLIITests
//
//  Created by Morten Bertz on 2022/02/25.
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

    func testURLEncoding() throws {
        let number=42
        let url=URL.deeplinkURL(number: 42)
        XCTAssert(url.numberFromDeepLink == number)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
