import XCTest
@testable import RollingDigitsLabel

final class RollingDigitsLabelTests: XCTestCase {
    
    var testLabel = RollingDigitsLabel()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        testLabel = RollingDigitsLabel()
    }
    
    func test_initialState() throws {
        XCTAssertEqual(testLabel.text, "0")
        XCTAssertEqual(testLabel.number, 0)
    }
    
    func test_setDoubleNumber() throws {
        testLabel.setNumber(Double(85.86), animated: false)
        XCTAssertEqual(testLabel.text, "86")
        XCTAssertEqual(testLabel.number, 85.86)
    }
    
    func test_setIntegerNumber() throws {
        testLabel.setNumber(Int(85.86), animated: false)
        XCTAssertEqual(testLabel.text, "85")
        XCTAssertEqual(testLabel.number, 85)
    }
    
    func test_setFloatNumber() throws {
        testLabel.setNumber(Float(85.86), animated: false)
        XCTAssertEqual(testLabel.text, "86")
        XCTAssertEqual(testLabel.number, 85.86000061035156)
    }
    
    func test_setNSNumber() throws {
        testLabel.setNumber(NSNumber(85.86), animated: false)
        XCTAssertEqual(testLabel.text, "86")
        XCTAssertEqual(testLabel.number, 85.86)
    }
    
    func test_accessibility() throws {
        testLabel.setNumber(85, animated: false)
        XCTAssertEqual(testLabel.accessibilityLabel, "85")
    }
    
    func test_numberStyle() throws {
        testLabel.setNumber(1985.86, animated: false)
        
        testLabel.numberStyle = .decimal
        XCTAssertEqual(testLabel.text, "1,985.86")
        
        testLabel.numberStyle = .currency
        XCTAssertEqual(testLabel.text, "$1,985.86")
        
        testLabel.numberStyle = .percent
        XCTAssertEqual(testLabel.text, "198,586%")
    }
    
    func test_minimumIntegerDigits() throws {
        testLabel.setNumber(1985.86, animated: false)
        
        testLabel.minimumIntegerDigits = 1
        XCTAssertEqual(testLabel.text, "1986")
        
        testLabel.minimumIntegerDigits = 3
        XCTAssertEqual(testLabel.text, "1986")
        
        testLabel.minimumIntegerDigits = 10
        XCTAssertEqual(testLabel.text, "0000001986")
    }
    
    func test_maximumIntegerDigits() throws {
        testLabel.setNumber(1985.86, animated: false)
        
        testLabel.maximumIntegerDigits = 1
        XCTAssertEqual(testLabel.text, "6")
        
        testLabel.maximumIntegerDigits = 3
        XCTAssertEqual(testLabel.text, "986")
        
        testLabel.maximumIntegerDigits = 10
        XCTAssertEqual(testLabel.text, "1986")
    }
    
    func test_minimumFractionDigits() throws {
        testLabel.setNumber(1985.8617, animated: false)
        
        testLabel.minimumFractionDigits = 1
        XCTAssertEqual(testLabel.text, "1985.9")
        
        testLabel.minimumFractionDigits = 3
        XCTAssertEqual(testLabel.text, "1985.862")
        
        testLabel.minimumFractionDigits = 10
        XCTAssertEqual(testLabel.text, "1985.8617000000")
    }
    
    func test_maximumFractionDigits() throws {
        testLabel.setNumber(1985.86, animated: false)
        
        testLabel.maximumFractionDigits = 1
        XCTAssertEqual(testLabel.text, "1985.9")
        
        testLabel.maximumFractionDigits = 3
        XCTAssertEqual(testLabel.text, "1985.86")
        
        testLabel.maximumFractionDigits = 10
        XCTAssertEqual(testLabel.text, "1985.86")
    }
}
