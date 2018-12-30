import UIKit

protocol View: class {
  func set(title: String, subtitle: String)
  func set(boardVisible: Bool)
}

protocol Repository: class {
  func getItems(onSuccess: @escaping ([String]) -> Void)
  func getItems(page: Int, onSuccess: @escaping ([String]) -> Void)
}

class Presenter {
  
  private let view: View
  private let repository: Repository
  
  init(view: View, repository: Repository) {
    self.view = view
    self.repository = repository
  }
 
  func onViewDidLoad() {
    view.set(title: "Text", subtitle: "Cat")
    view.set(title: "Text", subtitle: "Cat")
    view.set(boardVisible: true)
    view.set(title: "Text1", subtitle: "Dog")
  }
  
  func onUpdateTapped() {
    repository.getItems() { items in
      self.view.set(boardVisible: true)
      self.view.set(title: "Updated", subtitle: "Up")
    }
  }
  
  func onPickerTapped() {
    repository.getItems(page: 2) { items in
      self.view.set(boardVisible: true)
      self.view.set(title: "Updated", subtitle: "Up")
    }
  }
}

class ViewController: UIViewController, View {

  func set(title: String, subtitle: String) {}
  func set(boardVisible: Bool) {}
}

class RepositoryImp: Repository {
  func getItems(onSuccess: @escaping ([String]) -> Void) {}
  func getItems(page: Int, onSuccess: @escaping ([String]) -> Void) {}
}
