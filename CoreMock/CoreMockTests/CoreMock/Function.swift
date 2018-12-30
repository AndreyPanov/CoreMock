class Function: Equatable {
  let name: FunctionName
  var args: [Equivalent]
  
  init(name: FunctionName) {
    self.name = name
    args = []
  }
}

func == (l: Function, r: Function) -> Bool {
  for (lArgs, rArgs) in zip(l.args, r.args) {
    if !lArgs.isEqualTo(rArgs) {
      return false
    }
  }
  return l.name == r.name
}

extension Function: CustomStringConvertible {
  var description: String {
    return name
  }
}
