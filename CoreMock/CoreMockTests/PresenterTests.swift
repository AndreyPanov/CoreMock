import XCTest
@testable import CoreMock

class PresenterTests: BaseTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
}


class ViewMock: View, Mock {
  
  let callHandler: CallHandler
  
  init(with testCase: BaseTestCase) {
    callHandler = CallHandler(withTestCase: testCase)
  }
  
  func instanceType() -> ViewMock {
    return self
  }
}
