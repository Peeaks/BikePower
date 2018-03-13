import Foundation
import CoreBluetooth

protocol ConnectionsPresenterProtocol: class {
    
    func presentPeripherals(connectedHeartRatePeripheral: CBPeripheral?, connectedPowerPeripheral: CBPeripheral?, heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral])
    
}
