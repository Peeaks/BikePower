import Foundation
import CoreBluetooth

let sharedMockBLEManager = MockBLEManager()

class MockBLEManager {
    var heartRateChanged: ((Int) -> Void)?
    var powerChanged: ((PowerData) -> Void)?
    
    init() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.heartRateChanged?(Int(arc4random_uniform(140) + 65))
            self.powerChanged?(PowerData(power: Int(arc4random_uniform(300) + 85), cadence: Double(arc4random_uniform(45) + 80), distanceInMeters: 44, speedInMetersPerSecond: Double(arc4random_uniform(4) + 4)))
        }
    }
}

extension MockBLEManager: BLEManagerProtocol {
    
    func startScanning() {
        print("startScanning() called in mocked BLEManager")
    }
    
    func stopScanning() {
        print("stopScanning() called in mocked BLEManager")
    }
    
    func connectToHeartRate(peripheral: CBPeripheral) {
        print("connectToHeartRate(peripheral: CBPeripheral) called in mocked BLEManager")
    }
    
    func connectToCyclingPower(peripheral: CBPeripheral) {
        print("connectToCyclingPower(peripheral: CBPeripheral) called in mocked BLEManager")
    }
    
    
}
