import XCTest

typealias FunctionName = String

class BaseTestCase: XCTestCase {
  
  var callHistory: [FunctionName]!
  var callMockHistory: [FunctionName]!
  
  private var callHandlers: [CallHandler] = []
  
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
      XCTFail("Expected to verify \(callHistory.count) method calls. Instead got \(callMockHistory.count)",
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
  
  func clearCallHistory() {
    callHistory = []
    callMockHistory = []
    for handler in callHandlers {
      handler.clearCallHistory()
    }
  }
  
  func add(_ callHandler: CallHandler) {
    callHandlers.append(callHandler)
  }
}
