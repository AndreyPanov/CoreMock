import XCTest

extension XCTestCase {
  
  /// Checks if the given method is invoked with the given times. 
  /// In most cases, expectation is only once, therefore default is set to 1
  ///
  ///     verify(presenter.loginWasCalled)    // Default 1
  ///     verify(presenter.registrationWasCalled, times: 5)
  ///
  /// - parameters:
  ///   - method: Method invoke count
  ///   - times: The expectation count, as default it is 1
  
  func verify(_ method: Int, times: Int = 1, file: StaticString = #file, line: UInt = #line) {
    XCTAssertTrue(
      method == times,
      "Given method is not invoked \(times), but invoked \(method) times.",
      file: file,
      line: line
    )
  }
  
  /// Checks if the given method is invoked with the given mode.
  /// In most cases, expectation is only once, therefore default is set to Once
  ///
  ///     verify(presenter).login()             // Times 1
  ///     verify(presenter, Times(2)).login()   // Times 2
  ///     verify(presenter, Never()).login()    // Times 0
  ///
  /// - parameters:
  ///   - method: Method invoke count
  ///   - times: The expectation count, as default it is 1
  
  func verify<T: Mock>(_ mock: T, _ invoked: Invoke = .none) -> T.InstanceType {
    //добавить
    
    return mock.verify(invoked: invoked)
  }
  /// When using 'verify' to assert that the given method is not invoked, we can pass 0
  /// But in order to increase readability, instead of literal 0, we can use 'never' property.
  ///
  ///     verify(loginWasCalled, times:never)
  
  var never: Int {
    return 0
  }

  func wait(for timeInterval: TimeInterval) {
    let loopUntil = Date(timeIntervalSinceNow: timeInterval)

    while loopUntil.timeIntervalSinceNow > 0 {
      RunLoop.current.run(mode: RunLoop.Mode.default, before: loopUntil)
    }
  }
}
