import Foundation

protocol Equivalent {
  func isEqualTo(_ other: Equivalent) -> Bool
}

extension String: Equivalent {
  func isEqualTo(_ other: Equivalent) -> Bool {
    return self == (other as? String)
  }
}

extension Bool: Equivalent {
  func isEqualTo(_ other: Equivalent) -> Bool {
    return self == (other as? Bool)
  }
}

extension Int: Equivalent {
  func isEqualTo(_ other: Equivalent) -> Bool {
    return self == (other as? Int)
  }
}

enum Argument {
  case value(Equivalent)
  case values([Equivalent])
}
