import Foundation

protocol ConnectionsViewControllerProtocol: class {
    var eventHandler: ConnectionsEventHandlerProtocol { get }
    var viewModel: ConnectionsViewModel? { get set }

}
