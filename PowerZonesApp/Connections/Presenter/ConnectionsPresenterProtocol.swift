import Foundation
import CoreBluetooth

protocol ConnectionsPresenterProtocol: class {
    
    func presentPeripherals(connectedPeripherals: [CBPeripheral], heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral])
    
}
