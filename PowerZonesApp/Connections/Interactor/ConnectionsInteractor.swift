import Foundation
import CoreBluetooth

class ConnectionsInteractor {
    
    weak var presenter: ConnectionsPresenterProtocol?
    lazy var entityGateway: ConnectionsEntityGatewayProtocol = ConnectionsEntityGateway(interactor: self)
    
    private var connectedPeripherals = [CBPeripheral]()
    private var heartRatePeripherals = [CBPeripheral]()
    private var cyclingPowerPeripherals = [CBPeripheral]()
    
    init(presenter: ConnectionsPresenterProtocol) {
        self.presenter = presenter
        
        sharedBLEManager.heartRatePeripheralDiscovered = heartRatePeripheralDiscovered
        sharedBLEManager.cyclingPowerPeripheralDiscovered = cyclingPowerPeripheralDiscovered
        
        sharedBLEManager.connectedToPeripheral = connectedToPeripheral
        sharedBLEManager.disconnectedFromPeripheral = disconnectedFromPeripheral
    }
    
    func heartRatePeripheralDiscovered(peripheral: CBPeripheral) {
        print("Found peripheral: \(peripheral.name ?? "No name found")")
        heartRatePeripherals.append(peripheral)
        presentPeripherals()
    }
    
    func cyclingPowerPeripheralDiscovered(peripheral: CBPeripheral) {
        print("Found peripheral: \(peripheral.name ?? "No name found")")
        cyclingPowerPeripherals.append(peripheral)
        presentPeripherals()
    }
    
    func connectedToPeripheral(peripheral: CBPeripheral) {
        connectedPeripherals.append(peripheral)
        presentPeripherals()
    }
    
    func disconnectedFromPeripheral(peripheral: CBPeripheral) {
        if let index = connectedPeripherals.index(of: peripheral) {
            connectedPeripherals.remove(at: index)
        }
        presentPeripherals()
    }

}

extension ConnectionsInteractor: ConnectionsInteractorProtocol {
    
    //In
    func didLoad() {
        print("Starting BLE scan")
        sharedBLEManager.startScanning()
    }
    
    func didDisappear() {
        print("Stopping BLE scan")
        sharedBLEManager.stopScanning()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            sharedBLEManager.connectToHeartRate(peripheral: heartRatePeripherals[indexPath.row])
        case 1:
            sharedBLEManager.connectToCyclingPower(peripheral: cyclingPowerPeripherals[indexPath.row])
        default:
            break
        }
    }
    
    //Out
    func presentPeripherals() {
        presenter?.presentPeripherals(connectedPeripherals: connectedPeripherals, heartRatePeripherals: heartRatePeripherals, cyclingPowerPeripherals: cyclingPowerPeripherals)
    }
}
