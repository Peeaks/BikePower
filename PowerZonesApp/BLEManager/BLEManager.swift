import Foundation
import CoreBluetooth
import SwiftLog

let sharedBLEManager = BLEManager()

let heartRateServiceCBUUID = CBUUID(string: "0x180D")
let cyclingPowerServiceCBUUID = CBUUID(string: "0x1818")
//let cyclingSpeedAndCadenceServiceCBUUID = CBUUID(string: "0x1816")

let heartRateMeasurementCharacteristicCBUUID = CBUUID(string: "2A37")
//let bodySensorLocationCharacteristicCBUUID = CBUUID(string: "2A38")
let cyclingPowerMeasurementCharacteristicCBUUID = CBUUID(string: "2A63")
//let cyclingSpeedAndCadenceMeasurementCharacteristicCBUUID = CBUUID(string: "2A5B")

class BLEManager: NSObject {
    
    var centralManager: CBCentralManager!
    var heartRatePeripheral: CBPeripheral?
    var bikePeripheral: CBPeripheral?
    
    var heartRatePeripheralDiscovered: ((CBPeripheral) -> Void)?
    var cyclingPowerPeripheralDiscovered: ((CBPeripheral) -> Void)?
    
    var connectedToPeripheral: ((CBPeripheral) -> Void)?
    var disconnectedFromPeripheral: ((CBPeripheral) -> Void)?
    
    var heartRateChanged: ((Int) -> Void)?
    var powerChanged: ((PowerData) -> Void)?
    
    var lastPowerMeasurement: PowerMeasurement?
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
}

extension BLEManager: BLEManagerProtocol {
    func startScanning() {
        logw("--- startScanning called ---")
        // Wait a second to make sure the CBCentralManager is powered on
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            switch self.centralManager.state {
            case .unknown:
                logw("central.state is .unknown")
            case .resetting:
                logw("central.state is .resetting")
            case .unsupported:
                logw("central.state is .unsupported")
            case .unauthorized:
                logw("central.state is .unauthorized")
            case .poweredOff:
                logw("central.state is .poweredOff")
            case .poweredOn:
                logw("central.state is .poweredOn")
                self.centralManager.scanForPeripherals(withServices: [heartRateServiceCBUUID, cyclingPowerServiceCBUUID])
            }
        }
        logw("--- end of StartScanning ---")
    }
    
    func stopScanning() {
        logw("--- stopScanning called ---")
        centralManager.stopScan()
        logw("--- end of StartScanning ---")
    }
    
    func connectToHeartRate(peripheral: CBPeripheral) {
        logw("--- connectToHeartRate called ---")
        logw("Attempting to connect to: \(peripheral.name ?? "no name found")")
            self.heartRatePeripheral = peripheral
            self.heartRatePeripheral!.delegate = self
            centralManager.connect(self.heartRatePeripheral!)
        logw("--- end of connectToHeartRate ---")
    }
    
    func connectToCyclingPower(peripheral: CBPeripheral) {
        logw("--- connectToCyclingPower called ---")
        logw("Attempting to connect to: \(peripheral.name ?? "no name found")")
            self.bikePeripheral = peripheral
            self.bikePeripheral!.delegate = self
            centralManager.connect(self.bikePeripheral!)
        logw("--- end of connectToCyclingPower ---")
    }
    
    func disconnectFromHeartRateDevice() {
        logw("--- disconnectFromHeartRateDevice called ---")
        guard let peripheral = self.heartRatePeripheral else {
            return
        }
        logw("Attempting to disconnect from: \(peripheral.name ?? "no name found")")
        centralManager.cancelPeripheralConnection(peripheral)
        self.heartRatePeripheral = nil
        logw("--- end of disconnectFromHeartRateDevice ---")
    }
    
    func disconnectFromPowerDevice() {
        logw("--- disconnectFromPowerDevice called ---")
        guard let peripheral = self.bikePeripheral else {
            return
        }
        logw("Attempting to disconnect from: \(peripheral.name ?? "no name found")")
        centralManager.cancelPeripheralConnection(peripheral)
        self.bikePeripheral = nil
        logw("--- end of disconnectFromHeartRateDevice ---")
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        let data = advertisementData["kCBAdvDataServiceUUIDs"] as! NSArray
        
        if data[0] as! CBUUID == heartRateServiceCBUUID {
            logw("Heart rate device discovered")
            heartRatePeripheralDiscovered?(peripheral)
        } else if data[0] as! CBUUID == cyclingPowerServiceCBUUID {
            logw("Cycling power device discovered")
            cyclingPowerPeripheralDiscovered?(peripheral)
        } else {
            logw("Unsupported BLE device discovered")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        logw("Connected to peripheral: \(peripheral.name ?? "No name found")")
        connectedToPeripheral?(peripheral)
        peripheral.discoverServices([])
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        logw("Disconnected from peripheral: \(peripheral.name ?? "No name found")")
        disconnectedFromPeripheral?(peripheral)
    }
}

extension BLEManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        logw(String("Printing all services found in \(peripheral.name ?? "No name found")"))
        for service in services {
            logw(service.description)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        logw(String("Printing all characteristics found in \(service.description )"))
        for characteristic in characteristics {
            if characteristic.properties.contains(.notify) {
                logw(characteristic.description)
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        switch characteristic.uuid {
        case heartRateMeasurementCharacteristicCBUUID:
            logw("heartRateMeasurementCharacteristic UUID found")
            let bpm = heartRate(from: characteristic)
            heartRateChanged?(bpm)
        case cyclingPowerMeasurementCharacteristicCBUUID:
            logw("cyclingPowerMeasurementCharacteristic UUID found")
            let powerData = calculatePower(from: characteristic)
            powerChanged?(powerData)
        default:
            logw("Unhandled Characteristic UUID: \(characteristic.uuid)")
        }
    }
    
    private func heartRate(from characteristic: CBCharacteristic) -> Int {
        guard let characteristicData = characteristic.value else { return -1 }

        let measurement = HeartRateMeasurement(data: characteristicData)        
        return measurement.heartRate
    }
    
    private func calculatePower(from characteristic: CBCharacteristic) -> PowerData {
        guard let characteristicData = characteristic.value else {
            return PowerData(power: -1, cadence: nil, distanceInMeters: nil, speedInMetersPerSecond: nil)
        }
        let measurement = PowerMeasurement(data: characteristicData, wheelSize: 2105)
        
        let values = measurement.valuesForPreviousMeasurement(previousSample: lastPowerMeasurement)
        self.lastPowerMeasurement = measurement
        
        guard let powerData = values else {
            return PowerData(power: -1, cadence: nil, distanceInMeters: nil, speedInMetersPerSecond: nil)
        }
        
        return powerData
    }
    
}
