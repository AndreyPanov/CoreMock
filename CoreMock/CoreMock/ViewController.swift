import UIKit

protocol View: class {
  func set(title: String)
  func set(boardVisible: Bool)
}

protocol Repository: class {
  func getItems(onSuccess: @escaping ([String]) -> Void)
}

class Presenter {
  
  private let view: View
  private let repository: Repository
  
  init(view: View, repository: Repository) {
    self.view = view
    self.repository = repository
  }
 
  func onViewDidLoad() {
    view.set(title: "Text")
  }
  
  func onUpdateTapped() {
    repository.getItems() { items in
      self.view.set(boardVisible: true)
      self.view.set(title: "Updated")
    }
  }
}

class ViewController: UIViewController, View {

  func set(title: String) {}
  func set(boardVisible: Bool) {}
}

class RepositoryImp: Repository {
  func getItems(onSuccess: @escaping ([String]) -> Void) {}
}
