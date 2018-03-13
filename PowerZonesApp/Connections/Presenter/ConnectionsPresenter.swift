import UIKit
import CoreBluetooth

class ConnectionsPresenter {
    weak var viewController: ConnectionsViewControllerProtocol?
    lazy var interactor: ConnectionsInteractorProtocol = ConnectionsInteractor(presenter: self)
    var router: (NSObjectProtocol & ConnectionsRouterProtocol & ConnectionsDataPassing)?

//    var routeModel: RouteModelProtocol?
    
    init(viewController: ConnectionsViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func refreshViewModel(connectedPeripherals: [CBPeripheral], heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral]) {
        let heartRateTransformer: (CBPeripheral) -> (ConnectionsCellViewModel) = { peripheral in
            let connected = connectedPeripherals.contains(peripheral)
            return ConnectionsCellViewModel(active: connected, type: .HR, name: peripheral.name ?? "No name found")
        }
        let cyclingPowerTransformer: (CBPeripheral) -> (ConnectionsCellViewModel) = { peripheral in
            let connected = connectedPeripherals.contains(peripheral)
            return ConnectionsCellViewModel(active: connected, type: .PWR, name: peripheral.name ?? "No name found")
        }
        
        let heartRateCellViewModels = heartRatePeripherals.map(heartRateTransformer)
        let cyclingPowerCellViewModels = cyclingPowerPeripherals.map(cyclingPowerTransformer)
        
        let viewModel = ConnectionsViewModel(heartRateCellViewModels: heartRateCellViewModels, cyclingPowerCellViewModels: cyclingPowerCellViewModels)
        
        viewController?.viewModel = viewModel
    }
}

extension ConnectionsPresenter: ConnectionsEventHandlerProtocol {
    
    func prepare(for segue: UIStoryboardSegue) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    func didLoad() {
        interactor.didLoad()
    }
    
    func didDisappear() {
        interactor.didDisappear()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        interactor.didSelectRowAt(indexPath: indexPath)
    }
}

extension ConnectionsPresenter: ConnectionsPresenterProtocol {
    //Present something from the interactor
    func presentPeripherals(connectedPeripherals: [CBPeripheral], heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral]) {
        refreshViewModel(connectedPeripherals: connectedPeripherals, heartRatePeripherals: heartRatePeripherals, cyclingPowerPeripherals: cyclingPowerPeripherals)
    }
}

