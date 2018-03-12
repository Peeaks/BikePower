import Foundation
import CoreBluetooth

struct PowerMeasurement {
    
    let wheelSize: UInt32
    
    let pedalPowerBalancePresent: Bool
    let pedalPowerBalanceReference: Bool
    let accumulatedTorquePresent: Bool
    let accumulatedTorqueSource: Bool
    let wheelRevolutionDataPresent: Bool
    let crankRevolutionDataPresent: Bool
    let extremeForceMagnitudesresent: Bool
    let extremeTorqueMagnitudesPresent: Bool
    let extremeAnglesPresent: Bool
    let topDeadSpotAnglePresent: Bool
    let bottomDeadSpotAnglePresent: Bool
    let accumulatedEnergyPresent: Bool
    let offsetCompensationIndicator: Bool
    
    let power: UInt16
    
    let cumulativeWheel: UInt32
    let lastWheelEventTime: TimeInterval
    let cumulativeCrank: UInt16
    let lastCrankEventTime: TimeInterval
    
    init(data: Data, wheelSize: UInt32) {
        let bytes = [UInt8](data)
        
        self.wheelSize = wheelSize
        
        // Flags
        let flags1: UInt8 = bytes[0]
        let flags2: UInt8 = bytes[1]
        
        self.pedalPowerBalancePresent = ((flags1 & 0x01) > 0)
        self.pedalPowerBalanceReference = ((flags1 & 0x02) > 0)
        self.accumulatedTorquePresent = ((flags1 & 0x03) > 0)
        self.accumulatedTorqueSource = ((flags1 & 0x04) > 0)
        self.wheelRevolutionDataPresent = ((flags1 & 0x05) > 0)
        self.crankRevolutionDataPresent = ((flags1 & 0x06) > 0)
        self.extremeForceMagnitudesresent = ((flags1 & 0x07) > 0)
        self.extremeTorqueMagnitudesPresent = ((flags1 & 0x08) > 0)
        self.extremeAnglesPresent = ((flags2 & 0x01) > 0)
        self.topDeadSpotAnglePresent = ((flags2 & 0x02) > 0)
        self.bottomDeadSpotAnglePresent = ((flags2 & 0x03) > 0)
        self.accumulatedEnergyPresent = ((flags2 & 0x04) > 0)
        self.offsetCompensationIndicator = ((flags2 & 0x05) > 0)
        
        let powerArray: [UInt8] = [bytes[2], bytes[3]]
        let powerBigEndianValue = powerArray.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
            }.pointee
        self.power = UInt16(bigEndian: powerBigEndianValue)
        
        var wheel: UInt32 = 0
        var wheelTime: UInt16 = 0
        var crank: UInt16 = 0
        var crankTime: UInt16 = 0
        
        // Check if Wheel measurement data is present
        if self.wheelRevolutionDataPresent {
            let wheelArray: [UInt8] = [bytes[7], bytes[8], bytes[9], bytes[10]]
            let wheelBigEndianValue = wheelArray.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt32.self, capacity: 1) { $0 })
                }.pointee
            wheel = UInt32(bigEndian: wheelBigEndianValue)
            
            let wheelTimeArray: [UInt8] = [bytes[11], bytes[12]]
            let wheelTimeBigEndianValue = wheelTimeArray.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
                }.pointee
            wheelTime = UInt16(bigEndian: wheelTimeBigEndianValue)
        }
        
        // Check if Crank measurement data is present
        if self.crankRevolutionDataPresent {
            let crankArray: [UInt8] = [bytes[13], bytes[14]]
            let crankBigEndianValue = crankArray.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
                }.pointee
            crank = UInt16(bigEndian: crankBigEndianValue)
            
            let crankTimeArray: [UInt8] = [bytes[15], bytes[16]]
            let crankTimeBigEndianValue = crankTimeArray.withUnsafeBufferPointer {
                ($0.baseAddress!.withMemoryRebound(to: UInt16.self, capacity: 1) { $0 })
                }.pointee
            crankTime = UInt16(bigEndian: crankTimeBigEndianValue)
        }
        
        self.cumulativeWheel = CFSwapInt32LittleToHost(wheel)
        self.lastWheelEventTime = TimeInterval(Double(CFSwapInt16LittleToHost(wheelTime) / 1024))
        self.cumulativeCrank = CFSwapInt16LittleToHost(crank)
        self.lastCrankEventTime = TimeInterval(Double(CFSwapInt16LittleToHost(crankTime) / 1024))
    }
    
    func timeIntervalForCurrentSample( current: TimeInterval, previous: TimeInterval) -> TimeInterval {
        var timeDiff: TimeInterval = 0
        if current >= previous {
            timeDiff = current - previous
        } else {
            // Passed the maximum value
            timeDiff = ( TimeInterval((Double(UINT16_MAX) / 1024)) - previous) + current
        }
        return timeDiff
    }
    
    func valueDiffForCurrentSample<T: UnsignedInteger>(current: T, previous: T, max: T) -> T {
        var diff: T = 0
        if current >= previous {
            diff = current - previous
        } else {
            diff = (max - previous) + current
        }
        return diff
    }
    
    func valuesForPreviousMeasurement( previousSample: PowerMeasurement?) -> PowerData? {
        var distance: Double?
        var cadence: Double?
        var speed: Double?
        
        guard let previousSample = previousSample else {
            return nil
        }
        
        if wheelRevolutionDataPresent && previousSample.wheelRevolutionDataPresent {
            let wheelTimeDiff = timeIntervalForCurrentSample(current: lastWheelEventTime, previous: previousSample.lastWheelEventTime)
            let valueDiff = valueDiffForCurrentSample(current: cumulativeWheel, previous: previousSample.cumulativeWheel, max: UInt32.max)
            
            distance = Double(valueDiff * wheelSize) / 1000.0 // Distance in meters
            if distance != nil && wheelTimeDiff > 0 {
                speed = (wheelTimeDiff == 0) ? 0 : distance! / wheelTimeDiff // m/s
            }
        }
        
        if crankRevolutionDataPresent && previousSample.crankRevolutionDataPresent {
            let crankDiffTime = timeIntervalForCurrentSample(current: lastCrankEventTime, previous: previousSample.lastCrankEventTime)
            let valueDiff = Double(valueDiffForCurrentSample(current: cumulativeCrank, previous: previousSample.cumulativeCrank, max: UInt16.max))
            
            cadence = (crankDiffTime == 0) ? 0 : Double(60.0 * valueDiff / crankDiffTime) // RPM
        }
        
        return PowerData(power: Int(self.power), cadence: cadence, distanceInMeters: distance, speedInMetersPerSecond: speed)
    }
    
}
