import XCTest
@testable import CoreMock

class PresenterTests: BaseTestCase {

  private var presenter: Presenter!
  private var view: ViewMock!
  private var repository: RepositoryMock!
  
  override func setUp() {
    super.setUp()
    
    view = ViewMock(with: self)
    repository = RepositoryMock(with: self)
    presenter = Presenter(view: view, repository: repository)
  }
  
  override func tearDown() {
    view = nil
    repository = nil
    presenter = nil
    
    super.tearDown()
  }
  
  func testOnViewDidLoad() {
    presenter.onViewDidLoad()
    
    verify(view).set(title: "Text", subtitle: "Cat")
    verify(view).set(title: "Text", subtitle: "Cat")
    verify(view).set(boardVisible: true)
    verify(view).set(title: "Text1", subtitle: "Dog")
    AssertMockCallHistoryTrue()
  }
  
  func testOnUpdateTapped() {
    presenter.onUpdateTapped()
    
    verify(repository).getItems(onSuccess: {_ in })
    verify(view).set(boardVisible: true)
    verify(view).set(title: "Updated", subtitle: "Up")
    AssertMockCallHistoryTrue()
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
  
  func set(title: String, subtitle: String) {
    callHandler
      .accept(withFunction: #function, inFile: #file, atLine: #line)
      .join(arg: .string(title))
      .join(arg: .string(subtitle))
      .check(#function)
  }
  
  func set(boardVisible: Bool) {
    callHandler
      .accept(withFunction: #function, inFile: #file, atLine: #line)
      .join(arg: .bool(boardVisible))
      .check(#function)
  }
}

class RepositoryMock: Repository, Mock {
  let callHandler: CallHandler
  
  init(with testCase: BaseTestCase) {
    callHandler = CallHandler(withTestCase: testCase)
  }
  
  func instanceType() -> RepositoryMock {
    return self
  }
  
  func getItems(onSuccess: @escaping ([String]) -> Void) {
    callHandler
      .accept(withFunction: #function, inFile: #file, atLine: #line)
      .check(#function)
    onSuccess(["Cat", "Dog"])
  }
}
