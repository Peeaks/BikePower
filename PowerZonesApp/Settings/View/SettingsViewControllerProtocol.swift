import Foundation

protocol SettingsViewControllerProtocol: class {
    var eventHandler: SettingsEventHandlerProtocol { get }
    var viewModel: SettingsViewModel? { get set }

}
