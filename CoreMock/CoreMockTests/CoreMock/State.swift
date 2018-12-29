enum State: Equatable {
  case none, verify
}

enum Invoke: Equatable {
  case once // function should be called once
  case never // function shouldn't be called
  case times(Int) // function should be called number of times
  case none // function should be called at least once (call `AssertMockCallHistoryTrue()` at the end of the test recommended)
}
