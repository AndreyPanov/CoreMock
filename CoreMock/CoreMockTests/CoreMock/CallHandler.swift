import XCTest

class CallHandler {
  
  private(set) var state = State.none
  private var invoked = Invoke.none
  private var testCase: BaseTestCase
  
  private var original: [Equivalent] = []
  private var verified: [Equivalent] = []
  
  private var callHistory: [Function] = []
  private var callMockHistory: [Function] = []
  
  init(withTestCase testCase: BaseTestCase) {
    self.testCase = testCase
  }
  
  func verify(invoked: Invoke) {
    self.invoked = invoked
    state = .verify
  }
  
  @available(*, deprecated, message: "Use new method instead")
  @discardableResult func accept(_ returnValue: Any?, ofFunction function: String, atFile file: String,
              inLine line: Int, withArgs args: Any?...) -> Any? {
    accept(withFunction: function, inFile: file, atLine: line)
    return nil
  }
  
  @discardableResult
  func accept(withFunction function: String, inFile file: String, atLine line: Int) -> Self {
    guard invoked != .never else { return self }
    
    switch state {
    case .none:
      callHistory.append(function)
    case .verify:
      switch invoked {
      case .never: ()
      case .once, .none:
        callMockHistory.append(function)
      case .times(let number):
        (0..<number).forEach { _ in callMockHistory.append(function) }
      }
    }
    trackTestCase(function: function)
    return self
  }
  
  func join(arg: Equivalent) -> Self {
    if state == .none {
      original.append(arg)
      print("I appended \(arg) to state .none for the method \(callHistory.last!)")
    } else {
      switch invoked {
      case .never: ()
      case .once, .none:
        verified.append(arg)
      case .times(let number):
        (0..<number).forEach { _ in verified.append(arg) }
      }
      print("I appended \(arg) to state .verified for the method \(callMockHistory.last!)")
    }
    
    return self
  }
  
  func check(withFunction function: String, inFile file: String, atLine line: Int) {
    guard state == .verify else { return }
    guard original.count == verified.count else {
      doFail(
        "Expected to verify \(original.count) arguments. Instead got \(verified.count)",
        inFile: file,
        atLine: line
      )
      return
    }
    
    for (real, mock) in zip(original, verified) {
      if real != mock {
        doFail("Arguments are not equal for method \(function)", inFile: file, atLine: line)
      }
    }
    state = .none
    verifyCall(ofFunction: function, inFile: file, atLine: line)
  }
  
  private func verifyCall(ofFunction function: String, inFile file: String, atLine line: Int) {
    let numberOfCallsInReal = callHistory.filter { $0 == function }.count
    let numberOfCallsInMock = callMockHistory.filter { $0 == function }.count
    
    guard numberOfCallsInReal == numberOfCallsInMock else {
      doFail(
        "Expected to call \(numberOfCallsInReal) times but got \(numberOfCallsInMock) instead",
        inFile: file,
        atLine: line
      )
      return
    }
    
    switch invoked {
    case .once:
      if numberOfCallsInReal != 1 {
        doFail("Expected to call \(function) once but call \(numberOfCallsInReal) instead", inFile: file, atLine: line)
      }
    case .times(let number):
      if numberOfCallsInReal != number {
        doFail(
          "Expected to call \(function) \(number) times but call \(numberOfCallsInReal) instead",
          inFile: file,
          atLine: line
        )
      }
    case .never:
      if numberOfCallsInReal != 0 {
        doFail("Expected don't call \(function) but call \(numberOfCallsInReal) instead", inFile: file, atLine: line)
      }
    case .none: ()
    }
  }
  
  private func trackTestCase(function: String) {
    if state == .verify {
      testCase.callMockHistory.append(function)
    } else {
      testCase.callHistory.append(function)
    }
  }
  
  private func doFail(_ message: String, inFile file: String, atLine line: Int) {
    testCase.recordFailure(withDescription: message, inFile: file, atLine: Int(line), expected: true)
  }
}
