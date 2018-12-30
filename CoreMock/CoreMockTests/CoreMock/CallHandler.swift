import XCTest

/**
 Call this method first to track the function call
 
  func accept(withFunction function: String, inFile file: String, atLine line: Int) -> Self
 
 Append this method for args verificaton. You can append as many as arguments the function has.
 Don't forget to add new type in Equivalent enum
 
  func join(arg: Equivalent) -> Self
 
 This function needs to be appended at the end. Always. Otherwise, we can't start function number of calls.
 
  func check(_ function: String)
*/

class CallHandler {
  
  private(set) var state = State.none
  private var invoked = Invoke.none
  private let testCase: BaseTestCase
  
  private var callHistory: [Function] = []
  private var callMockHistory: [Function] = []
  
  init(withTestCase testCase: BaseTestCase) {
    self.testCase = testCase
  }
  
  func verify(invoked: Invoke) {
    self.invoked = invoked
    self.state = .verify
  }
  
  @available(*, deprecated, message: "Use the new method instead. This method works only for function order verification!")
  @discardableResult func accept(_ returnValue: Any?, ofFunction function: String, atFile file: String,
              inLine line: Int, withArgs args: Any?...) -> Any? {
    _ = accept(withFunction: function, inFile: file, atLine: line)
    return nil
  }
  
  func accept(withFunction function: String, inFile file: String, atLine line: Int) -> Self {
    let f = Function(name: function, file: file, line: line)
    switch state {
    case .none:
      callHistory.append(f)
    case .verify:
      switch invoked {
      case .never: ()
      case .once, .none:
        callMockHistory.append(f)
      case .times(let number):
        (0..<number).forEach { _ in callMockHistory.append(f) }
      }
    }
    trackTestCase(for: function)
    return self
  }
  
  func join(arg: Equivalent) -> Self {
    if state == .none {
      callHistory.last?.args.append(arg)
    } else {
      if invoked != .never {
        callMockHistory.last?.args.append(arg)
      }
    }
    return self
  }
  
  func check(_ function: String) {
    guard state == .verify else { return }
    
    let originalFunctions = callHistory.filter { $0.name == function }
    let verifiedFunctions = callMockHistory.filter { $0.name == function }
    
    switch invoked {
    case .never:
      if originalFunctions.isEmpty == false {
        doFail(
          "Expected don't call \(function) but call \(originalFunctions.count) instead",
          inFile: originalFunctions.first!.file,
          atLine: originalFunctions.first!.line
        )
      }
    case .once:
      if (originalFunctions.count != verifiedFunctions.count) || (originalFunctions.count != 1) {
        doFail(
          "Expected to call \(function) once but call \(originalFunctions.count) instead",
          inFile: originalFunctions.first!.file,
          atLine: originalFunctions.first!.line
        )
      }
    case .times(let number):
      if (originalFunctions.count != verifiedFunctions.count) || (originalFunctions.count != number) {
        doFail(
          "Expected don't call \(function) \(number) times but call \(originalFunctions.count) instead",
          inFile: originalFunctions.first!.file,
          atLine: originalFunctions.first!.line
        )
      }
    case .none:
      if originalFunctions.isEmpty {
        doFail(
          "Expected to call \(function) but don't call instead",
          inFile: originalFunctions.first!.file,
          atLine: originalFunctions.first!.line
        )
      }
    }
    
    for (real, mock) in zip(originalFunctions, verifiedFunctions) {
      verifyArgs(for: real, and: mock)
    }
    state = .none
  }
  
  private func verifyArgs(for originalFunction: Function, and verifiedFunction: Function) {
    for (real, mock) in zip(originalFunction.args, verifiedFunction.args) {
      if !real.isEqualTo(mock) {
        doFail(
          "Arguments are not equal for method \(originalFunction.name)",
          inFile: originalFunction.file,
          atLine: originalFunction.line
        )
      }
    }
  }
  
  private func trackTestCase(for function: String) {
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
