import Foundation
import CoreBluetooth

protocol BLEManagerProtocol {
    
    var heartRateChanged: ((Int) -> Void)? {get}
    var powerChanged: ((PowerData) -> Void)? {get}
    
    func startScanning()
    func stopScanning();
    func connectToHeartRate(peripheral: CBPeripheral)
    func connectToCyclingPower(peripheral: CBPeripheral)
}
