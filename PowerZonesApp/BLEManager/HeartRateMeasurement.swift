import Foundation
import CoreBluetooth

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
            self.heartRate = (Int(bytes[1]) << 8) | Int(bytes[2])
        } else {
            // Heart Rate Value is in the 2nd byte
            self.heartRate = Int(bytes[1])
        }
    }
    
}
