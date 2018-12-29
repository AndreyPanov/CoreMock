import XCTest

typealias Function = String

class BaseTestCase: XCTestCase {
  
  var callHistory: [Function]!
  var callMockHistory: [Function]!
  
  override open func setUp() {
    super.setUp()
    
    callHistory = []
    callMockHistory = []
  }
  
  override open func tearDown() {
    callHistory = nil
    callMockHistory = nil
    
    super.tearDown()
  }
  
  //swiftlint:disable identifier_name
  func AssertMockCallHistoryTrue(file: StaticString = #file, line: UInt = #line) {
    guard callHistory.count == callMockHistory.count else {
      XCTFail("\n\nExpected to verify \(callHistory.count) method calls. Instead got \(callMockHistory.count)",
        file: file, line: line)
      print("Real call history: \(String(describing: callHistory))")
      print("Expected call history: \(String(describing: callMockHistory))")
      return
    }
    
    for (real, mock) in zip(callHistory, callMockHistory) {
      if real != mock {
        XCTFail("Expected to verify \(real) method call. Instead got \(mock)",
          file: file, line: line)
        return
      }
    }
    XCTAssertTrue(true)
  }
  //swiftlint:enable identifier_name
  
  func clearHistory() {
    callHistory = []
    callMockHistory = []
  }
}
