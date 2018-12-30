class Function: Equatable {
  let name: FunctionName
  let file: String
  let line: Int
  var args: [Equivalent]
  
  init(name: FunctionName, file: String, line: Int) {
    self.name = name
    self.file = file
    self.line = line
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
    return "Function \(name) in \(file) at \(line)"
  }
}
