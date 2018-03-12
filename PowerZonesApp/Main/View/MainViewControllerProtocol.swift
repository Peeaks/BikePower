import Foundation

protocol MainViewControllerProtocol: class {
    var eventHandler: MainEventHandlerProtocol { get }
    var viewModel: MainViewModel? { get set }
}
