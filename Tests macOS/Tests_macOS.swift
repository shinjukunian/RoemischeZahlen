//
//  Tests_macOS.swift
//  Tests macOS
//
//  Created by Miho on 2021/04/29.
//

import XCTest
@testable import Roman_Numerals

class Tests_macOS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    

    func testLargeRoman() throws {
        // UI tests must launch the application that they test.
        let number=10_000
        let formatter=Roman_Numerals.ExotischeZahlenFormatter()
        let roemisch=try! XCTUnwrap(formatter.macheRömischeZahl(aus: number))
        
        XCTAssert(roemisch.isEmpty == false)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
