import Foundation
import CoreBluetooth

class ConnectionsInteractor {
    
    weak var presenter: ConnectionsPresenterProtocol?
    lazy var entityGateway: ConnectionsEntityGatewayProtocol = ConnectionsEntityGateway(interactor: self)
    
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
        if let index = heartRatePeripherals.index(of: peripheral) {
            heartRatePeripherals.remove(at: index)
        }
        if let index = cyclingPowerPeripherals.index(of: peripheral) {
            cyclingPowerPeripherals.remove(at: index)
        }
        
        presentPeripherals()
    }
    
    func disconnectedFromPeripheral(peripheral: CBPeripheral) {
//        if let index = connectedPeripherals.index(of: peripheral) {
//            connectedPeripherals.remove(at: index)
//        }
        presentPeripherals()
    }

}

extension ConnectionsInteractor: ConnectionsInteractorProtocol {
    
    //In
    func didLoad() {
        print("Starting BLE scan")
        presentPeripherals()
        sharedBLEManager.startScanning()
    }
    
    func didDisappear() {
        print("Stopping BLE scan")
        sharedBLEManager.stopScanning()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if sharedBLEManager.heartRatePeripheral != nil {
                // Cell 1 is always heart rate
                // Cell 2 is always power
                if indexPath.row == 0 {
                    sharedBLEManager.disconnectFromHeartRateDevice()
                } else if indexPath.row == 1 {
                    sharedBLEManager.disconnectFromPowerDevice()
                }
            } else {
                // There is no heart rate, so power must be Cell 1
                if indexPath.row == 0 {
                    sharedBLEManager.disconnectFromPowerDevice()
                }
            }
        case 1:
            sharedBLEManager.connectToHeartRate(peripheral: heartRatePeripherals[indexPath.row])
        case 2:
            sharedBLEManager.connectToCyclingPower(peripheral: cyclingPowerPeripherals[indexPath.row])
        default:
            break
        }
    }
    
    //Out
    func presentPeripherals() {
        presenter?.presentPeripherals( connectedHeartRatePeripheral: sharedBLEManager.heartRatePeripheral, connectedPowerPeripheral: sharedBLEManager.bikePeripheral, heartRatePeripherals: heartRatePeripherals, cyclingPowerPeripherals: cyclingPowerPeripherals)
    }
}
