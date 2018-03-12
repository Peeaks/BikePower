import Foundation
import CoreBluetooth

protocol ConnectionsPresenterProtocol: class {
    
    func presentPeripherals(heartRatePeripherals: [CBPeripheral], cyclingPowerPeripherals: [CBPeripheral])
    
}
