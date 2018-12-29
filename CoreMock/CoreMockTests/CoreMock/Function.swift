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
  return (l.name == r.name) && (l.args == r.args)
}

extension Function: CustomStringConvertible {
  var description: String {
    return "Function \(name) in \(file) at \(line)"
  }
}
