import Foundation
import CoreBluetooth
import SwiftLog

struct HeartRateMeasurement {
    
    let heartRateValueFormatBit: Bool
    let sensorContactStatusBit: Bool
    let energyExpendedStatusBit: Bool
    let RRIntervalBit: Bool
    
    let heartRate: Int
    
    init(data: Data) {
        let bytes = [UInt8](data)
        
        // Flags
        let flags: UInt8 = bytes[0]
        
        self.heartRateValueFormatBit = ((flags & 0x01) > 0)
        self.sensorContactStatusBit = ((flags & 0x02) > 0)
        self.energyExpendedStatusBit = ((flags & 0x03) > 0)
        self.RRIntervalBit = ((flags & 0x04) > 0)
        
        if heartRateValueFormatBit {
            // Heart Rate Value is in the 2nd and 3rd byte
//            self.heartRate = (Int(bytes[1]) << 8) | Int(bytes[2])
//            logw("Old way: \(self.heartRate)")
            let heartArray = [bytes[1], bytes[2]]
            self.heartRate = Int(heartArray.data.uint16)
//            logw("New way: \(self.heartRate)")
        } else {
            // Heart Rate Value is in the 2nd byte
            self.heartRate = Int(bytes[1])
        }
    }
    
}
