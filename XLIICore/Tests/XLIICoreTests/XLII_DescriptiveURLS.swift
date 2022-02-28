//
//  XLII_DescriptiveURLS.swift
//  
//
//  Created by Morten Bertz on 2022/02/26.
//

import XCTest
import XLIICore

class XLII_DescriptiveURLS: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testURLs() throws {
        let session = URLSession.shared
        let outputs = Output.builtin + [.numeric(base: 2), .numeric(base: 8), .numeric(base: 16)]
        
        let expectations = try outputs.map({output -> XCTestExpectation in
            let url=try XCTUnwrap(output.url, "\(output) url not available")
            let expectation=XCTestExpectation(description: "testing \(url)")
            let task=session.dataTask(with: url, completionHandler: {data, response, error in
                XCTAssertNotNil(data, "No data was downloaded. (\(url)")
                expectation.fulfill()
            })
            task.resume()
            return expectation
        })
        
        wait(for: expectations, timeout: 20)
        
    }

//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
