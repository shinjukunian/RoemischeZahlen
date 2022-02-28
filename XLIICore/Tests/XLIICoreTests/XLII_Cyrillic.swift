//
//  XLII_Cyrillic.swift
//  
//
//  Created by Morten Bertz on 2022/02/27.
//

import XCTest
@testable import XLIICore

class XLII_Cyrillic: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCyrillic() throws{
        
        let number=411791
        let expectation="҂У҂І҂аѱча"
        let result=try XCTUnwrap(CyrillicNumber(number: number))
        let cyrillic=result.cyrillic
        let matchRange=try XCTUnwrap(cyrillic.range(of: expectation, options: [.diacriticInsensitive,.caseInsensitive]))
        let same=matchRange == cyrillic.startIndex..<cyrillic.endIndex
        XCTAssert(same == true, "failed \(expectation) \(number) converted to \(cyrillic)")
        let expectationStripped=CyrillicNumber.strippingTitlo(expectation).uppercased()
        XCTAssert(expectationStripped == cyrillic, "failed \(expectationStripped) \(number) is not  \(cyrillic)")
        
        
        let cases=[1706:"҂аѱ҃ѕ", 17:"ЗІ", 707:"ѰЗ", 999:"ЦЧѲ", 6000:"҂Ѕ", 32000:"҂Л҂В", 23:"кг҃", 735:"ѱл҃е", 113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в", 8567:"҂ифѯ҃з", 999_999:"҂ц҂ч҂ѳ҃цчѳ"]
        
        for c in cases{
            let result=try XCTUnwrap(CyrillicNumber(number: c.key))
            let cyrillic=result.cyrilicUsingTitlo
            let matchRange=try XCTUnwrap(cyrillic.range(of: c.value, options: [.diacriticInsensitive,.caseInsensitive]), "\(c.value) doesnt match \(cyrillic)")
            let same=matchRange == cyrillic.startIndex..<cyrillic.endIndex
            XCTAssert(same == true, "failed \(c.key) \(c.value) converted to \(cyrillic)")
            XCTAssert(CyrillicNumber.numericallyEqual(cyrillic, c.value))
            let valueWithoutTitlo=CyrillicNumber.strippingTitlo(c.value)
            XCTAssert(result.cyrillic.lowercased() == valueWithoutTitlo.lowercased(), "result \(result.cyrillic) doesnt match \(c.value.lowercased())")
            
            XCTAssert(CyrillicNumber.canonicalForm(result.cyrilicUsingTitlo) == CyrillicNumber.canonicalForm(c.value), "result \(result.cyrilicUsingTitlo) doesnt match \(c.value)")
            
        }
        
        let titloCases=[1706:"҂аѱ҃ѕ", 23:"кг҃", 735:"ѱл҃е", 113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в", 8567:"҂ифѯ҃з", 78:"ои҃", 9999:"҂ѳцч҃ѳ"]
        
        for c in titloCases{
            let result=try XCTUnwrap(CyrillicNumber(number: c.key))
            let cyrillic=result.cyrilicUsingTitlo.lowercased()
            XCTAssert(cyrillic == c.value.lowercased(), "\(cyrillic) doesnt match \(c.value)")
            XCTAssert(cyrillic.uppercased() == c.value.uppercased(), "\(cyrillic.uppercased()) doesnt match \(c.value.uppercased())")
        }
    }
    
    func testLarge()throws{
        let titloCases=[
            1706:"҂аѱ҃ѕ", 23:"кг҃", 735:"ѱл҃е",
            113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в",
            8567:"҂ифѯ҃з", 78:"ои҃", 9999:"҂ѳцч҃ѳ",
            25517:"в⃝҂еф҃зі", 989976:"ѳ҈и⃝҂ѳцоѕ",
            1_200_567:"а҉в҈фѯз",
            12_987_090:"а꙰в҉ѳ҈и⃝҂зч",
            3_124_563_567:"г꙲а꙱в꙰д҉е҈ѕ⃝҂гфѯз",
            3567:"҂гфѯ҃з"
                        
        ]
        
        for c in titloCases{
            let result=try XCTUnwrap(CyrillicNumber(number: c.key, useMultiplicationModifiers: true), "failed for \(c.key)")
            XCTAssert(CyrillicNumber.numericallyEqual(result.cyrilicUsingTitlo, c.value), "\(result.cyrilicUsingTitlo) doesnt match expectation \(c.value)")
            
//            let cyrillic=result.cyrilicUsingTitlo.lowercased()
//            XCTAssert(cyrillic == c.value.lowercased(), "\(cyrillic) doesnt match \(c.value)")
//            XCTAssert(cyrillic.uppercased() == c.value.uppercased(), "\(cyrillic.uppercased()) doesnt match \(c.value.uppercased())")
        }
    }
    
    func testReverse()throws{
        let cases=[1706:"҂аѱ҃ѕ", 17:"ЗІ", 707:"ѰЗ", 999:"ЦЧѲ", 6000:"҂Ѕ", 32000:"҂Л҂В", 23:"кг҃", 735:"ѱл҃е", 113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в", 8567:"҂ифѯ҃з", 999_999:"҂ц҂ч҂ѳ҃цчѳ"]
        let titloCases=[1706:"҂аѱ҃ѕ", 23:"кг҃", 735:"ѱл҃е", 113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в", 8567:"҂ифѯ҃з", 78:"ои҃", 9999:"҂ѳцч҃ѳ"]

        let combined=cases.merging(titloCases, uniquingKeysWith: {s1, s2 in
            return s2
        })
        
        let number="҂ц҂ч҂ѳ҃цчѳ"
        let expectation=999_999

        let parser=try XCTUnwrap(CyrillicNumber(text: number))
        XCTAssert(parser.arabic == expectation, "parsing failed for \(number) [\(expectation)] parsed as \(parser.arabic)")
        
        
        for c in combined{
            let number=c.value
            let expectation=c.key
            let parser=try XCTUnwrap(CyrillicNumber(text: number))
            XCTAssert(parser.arabic == expectation, "parsing failed for \(number) [\(expectation)] parsed as \(parser.arabic)")
        
        }
        
        
        let random=(0..<2000).map({_ in return Int.random(in: 1..<1_000_000)})
        
        for number in random{
            let parser=try XCTUnwrap(CyrillicNumber(number: number), "conversion failed for \(number)")
            let cyrillic=parser.cyrilicUsingTitlo
            let reverse=try XCTUnwrap(CyrillicNumber(text: cyrillic), "initialization failed for \(cyrillic)")
            XCTAssert(reverse.arabic == number, "back conversion failed for \(cyrillic), result \(reverse.arabic), expected \(number)")
            
            let reverseNoDiacritics=try XCTUnwrap(CyrillicNumber(text: parser.cyrillic), "initialization failed for \(parser.cyrillic)")
            XCTAssert(reverseNoDiacritics.arabic == number, "back conversion failed for \(parser.cyrillic), result \(reverse.arabic), expected \(number)")

        
        }
    }
    
    func testReverseLarge() throws{
        let titloCases=[
            1706:"҂аѱ҃ѕ", 23:"кг҃", 735:"ѱл҃е",
            113:"рг҃і", 123:"рк҃г", 2022:"҂вк҃в",
            8567:"҂ифѯ҃з", 78:"ои҃", 9999:"҂ѳцч҃ѳ",
            25517:"в⃝҂еф҃зі", 989976:"ѳ҈и⃝҂ѳцоѕ",
            1_200_567:"а҉в҈фѯз",
            12_987_090:"а꙰в҉ѳ҈и⃝҂зч",
            3_124_563_567:"г꙲а꙱в꙰д҉е҈ѕ⃝҂гфѯз",
            3567:"҂гфѯ҃з"
                        
        ]
        
        let number="в⃝҂еф҃зі"
        let expectation=25517

        let parser=try XCTUnwrap(CyrillicNumber(text: number))
        XCTAssert(parser.arabic == expectation, "parsing failed for \(number) [\(expectation)] parsed as \(parser.arabic)")
        
        for c in titloCases{
            let number=c.value
            let expectation=c.key
            let parser=try XCTUnwrap(CyrillicNumber(text: number))
            XCTAssert(parser.arabic == expectation, "parsing failed for \(number) [\(expectation)] parsed as \(parser.arabic)")
        
        }
        
        let random=(0..<2000).map({_ in return Int.random(in: 1..<10_000_000_000)})
        
        for number in random{
            
            let parser=try XCTUnwrap(CyrillicNumber(number: number, useMultiplicationModifiers: Bool.random()), "conversion failed for \(number)")
            let cyrillic=parser.cyrilicUsingTitlo
            let reverse=try XCTUnwrap(CyrillicNumber(text: cyrillic), "initialization failed for \(cyrillic)")
            XCTAssert(reverse.arabic == number, "back conversion failed for \(cyrillic), result \(reverse.arabic), expected \(number)")
            
            let reverseNoDiacritics=try XCTUnwrap(CyrillicNumber(text: parser.cyrillic), "initialization failed for \(parser.cyrillic)")
            XCTAssert(reverseNoDiacritics.arabic == number, "back conversion failed for \(parser.cyrillic), result \(reverse.arabic), expected \(number)")

        }
    }
    
    
    

}
