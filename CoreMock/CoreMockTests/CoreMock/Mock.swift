protocol Mock {
  
  associatedtype InstanceType
  var callHandler: CallHandler { get }

  func instanceType() -> InstanceType
  func verify(invoked: Invoke, inFile file: String, atLine line: Int) -> InstanceType
}

extension Mock {

  func verify(invoked: Invoke, inFile file: String, atLine line: Int) -> InstanceType {
    callHandler.verify(invoked: invoked, inFile: file, atLine: line)
    return instanceType()
  }
}
