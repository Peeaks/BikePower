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
    
    func refreshViewModel(connectedHeartRatePeripheral: CBPeripheral?, connectedPowerPeripheral: CBPeripheral?, heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral]) {
        
        var connectedHeartRateCell: ConnectionsCellViewModel?
        if let unpackedConnectedHeartRatePeripheral = connectedHeartRatePeripheral {
            connectedHeartRateCell = ConnectionsCellViewModel(active: true, type: .HR, name: unpackedConnectedHeartRatePeripheral.name ?? "No name found")
        }
        var connectedPowerCell: ConnectionsCellViewModel?
        if let unpackedPowerPeripheral = connectedPowerPeripheral {
            connectedPowerCell = ConnectionsCellViewModel(active: true, type: .PWR, name: unpackedPowerPeripheral.name ?? "No name found")
        }
        
        var connectedDevicesViewModels = [ConnectionsCellViewModel]()
        if connectedHeartRateCell != nil {
            connectedDevicesViewModels.append(connectedHeartRateCell!)
        }
        if connectedPowerCell != nil {
            connectedDevicesViewModels.append(connectedPowerCell!)
        }
        
        let heartRateTransformer: (CBPeripheral) -> (ConnectionsCellViewModel) = { peripheral in
            return ConnectionsCellViewModel(active: false, type: .HR, name: peripheral.name ?? "No name found")
        }
        let cyclingPowerTransformer: (CBPeripheral) -> (ConnectionsCellViewModel) = { peripheral in
            return ConnectionsCellViewModel(active: false, type: .PWR, name: peripheral.name ?? "No name found")
        }
        
        let heartRateCellViewModels = heartRatePeripherals.map(heartRateTransformer)
        let cyclingPowerCellViewModels = cyclingPowerPeripherals.map(cyclingPowerTransformer)
        
        let viewModel = ConnectionsViewModel(connectedCellViewModels: connectedDevicesViewModels, heartRateCellViewModels: heartRateCellViewModels, cyclingPowerCellViewModels: cyclingPowerCellViewModels)
        
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
    func presentPeripherals(connectedHeartRatePeripheral: CBPeripheral?, connectedPowerPeripheral: CBPeripheral?, heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral]) {
        refreshViewModel(connectedHeartRatePeripheral: connectedHeartRatePeripheral,  connectedPowerPeripheral: connectedPowerPeripheral, heartRatePeripherals: heartRatePeripherals, cyclingPowerPeripherals: cyclingPowerPeripherals)
    }
    
}

