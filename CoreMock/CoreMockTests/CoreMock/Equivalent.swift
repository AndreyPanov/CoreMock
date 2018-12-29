import Foundation

enum Equivalent: Equatable {
  case uInt(UInt)
  case int(Int?)
  case string(String?)
  case date(Date?)
  case bool(Bool)
}

func == (lhs: Equivalent, rhs: Equivalent) -> Bool {
  switch (lhs, rhs) {
  case (let .uInt(value1), let .uInt(value2)):
    return value1 == value2
    
  case (let .int(value1), let .int(value2)):
    return value1 == value2
    
  case (let .string(value1), let .string(value2)):
    return value1 == value2
    
  case (let .date(value1), let .date(value2)):
    return value1 == value2
    
  case (let .bool(value1), let .bool(value2)):
    return value1 == value2
    
  default:
    return false
  }
}
