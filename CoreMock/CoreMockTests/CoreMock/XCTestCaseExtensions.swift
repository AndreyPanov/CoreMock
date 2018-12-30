import XCTest

extension XCTestCase {
  
  /// Checks if the given method is invoked with the given mode.
  /*
   All verify calls also verify the arguments of the method if we used `join()` function in mock.
   
   Case 1. We want to verify order of the calls.
   
      verify(view).set(title: "Text", subtitle: "Cat")
      verify(view).set(title: "Text", subtitle: "Cat")
      verify(view).set(boardVisible: true)
      verify(view).set(title: "Text1", subtitle: "Dog")
      AssertMockCallHistoryTrue()
   
   Case 2. We want to verify that methods were called a number of times
   
      verify(view, .never).set(title: "Text", subtitle: "Cat")
      verify(view, .once).set(title: "Text")
      verify(view, .times(2)).set(boardVisible: true)
  */
  
  func verify<T: Mock>(_ mock: T, _ invoked: Invoke = .none, inFile file: String = #file, atLine line: Int = #line) -> T.InstanceType {
    return mock.verify(invoked: invoked, inFile: file, atLine: line)
  }
  /// When using 'verify' to assert that the given method is not invoked, we can pass 0
  /// But in order to increase readability, instead of literal 0, we can use 'never' property.
  ///
  ///     verify(loginWasCalled, .never)
  
  func wait(for timeInterval: TimeInterval) {
    let loopUntil = Date(timeIntervalSinceNow: timeInterval)

    while loopUntil.timeIntervalSinceNow > 0 {
      RunLoop.current.run(mode: RunLoop.Mode.default, before: loopUntil)
    }
  }
}
