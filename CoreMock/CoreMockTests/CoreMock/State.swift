enum State: Equatable {
  case none, verify
}

enum Invoke: Equatable {
  case once, never, times(UInt), none
}
