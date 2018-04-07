import Foundation
import CoreBluetooth
import SwiftLog

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
        logw("--- NEW POWER DATA RECEIVED ---")
        let bytes = [UInt8](data)
        logw("Bytes received: \(bytes.description)")
        
        self.wheelSize = wheelSize
        
        // Flags
        let flagsArray: [UInt8] = [bytes[0], bytes[1]]
        let flags = flagsArray.data.uint16
        
        self.pedalPowerBalancePresent = ((flags >> 0) & 1) != 0
        self.pedalPowerBalanceReference = ((flags >> 1) & 1) != 0
        self.accumulatedTorquePresent = ((flags >> 2) & 1) != 0
        self.accumulatedTorqueSource = ((flags >> 3) & 1) != 0
        self.wheelRevolutionDataPresent = ((flags >> 4) & 1) != 0
        self.crankRevolutionDataPresent = ((flags >> 5) & 1) != 0
        self.extremeForceMagnitudesresent = ((flags >> 6) & 1) != 0
        self.extremeTorqueMagnitudesPresent = ((flags >> 7) & 1) != 0
        self.extremeAnglesPresent = ((flags >> 8) & 1) != 0
        self.topDeadSpotAnglePresent = ((flags >> 9) & 1) != 0
        self.bottomDeadSpotAnglePresent = ((flags >> 10) & 1) != 0
        self.accumulatedEnergyPresent = ((flags >> 11) & 1) != 0
        self.offsetCompensationIndicator = ((flags >> 12) & 1) != 0
        
        let powerArray: [UInt8] = [bytes[2], bytes[3]]
        self.power = powerArray.data.uint16
        logw("Power calculated to: \(self.power)")
        
        var wheel: UInt32 = 0
        var wheelTime: UInt16 = 0
        var crank: UInt16 = 0
        var crankTime: UInt16 = 0
        
        // Check if Wheel measurement data is present
        if self.wheelRevolutionDataPresent {
            logw("Wheel data is present")
            let wheelArray: [UInt8] = [bytes[4], bytes[5], bytes[6], bytes[7]]
            wheel = wheelArray.data.uint32
            logw("Wheel calculated to: \(wheel)")
            
            let wheelTimeArray: [UInt8] = [bytes[8], bytes[9]]
            wheelTime = wheelTimeArray.data.uint16
            logw("WheelTime calculated to: \(wheelTime)")
        }
        
        // Check if Crank measurement data is present
        if self.crankRevolutionDataPresent {
            logw("Crank data is present")
            let crankArray: [UInt8] = [bytes[10], bytes[11]]
            crank = crankArray.data.uint16
            logw("Crank calculated to: \(crank)")
            
            let crankTimeArray: [UInt8] = [bytes[12], bytes[13]]
            crankTime = crankTimeArray.data.uint16
        }
        
        self.cumulativeWheel = CFSwapInt32LittleToHost(wheel)
        logw("CumulativeWheel updated to: \(self.cumulativeWheel)")
        self.lastWheelEventTime = TimeInterval(Double(CFSwapInt16LittleToHost(wheelTime) / 1024))
        logw("LastWheelEventTime updated to: \(self.lastWheelEventTime)")
        self.cumulativeCrank = CFSwapInt16LittleToHost(crank)
        logw("CumulativeCrank updated to: \(self.cumulativeCrank)")
        self.lastCrankEventTime = TimeInterval(Double(CFSwapInt16LittleToHost(crankTime) / 1024))
        logw("LastCrankEventTime updated to: \(self.lastCrankEventTime)")
        
        logw("--- END OF NEW POWER DATA RECEIVED ---")
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
        logw("--- ValuesForPreviousMeasurement called ---")
        var distance: Double?
        var cadence: Double?
        var speed: Double?
        
        guard let previousSample = previousSample else {
            logw("No previous sample found")
            return nil
        }
        
        if wheelRevolutionDataPresent && previousSample.wheelRevolutionDataPresent {
            let wheelTimeDiff = timeIntervalForCurrentSample(current: lastWheelEventTime, previous: previousSample.lastWheelEventTime)
            logw("wheelTimeDiff calculated to: \(wheelTimeDiff)")
            let valueDiff = valueDiffForCurrentSample(current: cumulativeWheel, previous: previousSample.cumulativeWheel, max: UInt32.max)
            logw("valueDiff calculated to: \(valueDiff)")

            distance = Double(valueDiff * wheelSize) / 1000.0 // Distance in meters
            logw("distance calculated to: \(distance ?? -1) meters")
            if distance != nil && wheelTimeDiff > 0 {
                speed = (wheelTimeDiff == 0) ? 0 : distance! / wheelTimeDiff // m/s
                logw("speed calculated to: \(speed ?? -1) m/s")
            }
        }
        
        if crankRevolutionDataPresent && previousSample.crankRevolutionDataPresent {
            let crankDiffTime = timeIntervalForCurrentSample(current: lastCrankEventTime, previous: previousSample.lastCrankEventTime)
            logw("crankDiffTime calculated to: \(crankDiffTime)")
            let valueDiff = Double(valueDiffForCurrentSample(current: cumulativeCrank, previous: previousSample.cumulativeCrank, max: UInt16.max))
            logw("valueDiff calculated to: \(valueDiff)")
            
            cadence = (crankDiffTime == 0) ? 0 : Double(60.0 * valueDiff / crankDiffTime) // RPM
            logw("cadence calculated to: \(cadence ?? -1) rpm")
        }
        
        logw("--- END OF ValuesForPreviousMeasurement called --- ")
        
        return PowerData(power: Int(self.power), cadence: cadence, distanceInMeters: distance, speedInMetersPerSecond: speed)
    }
    
}

extension Data {
    var uint16: UInt16 {
        return withUnsafeBytes { $0.pointee }
    }
    
    var uint32: UInt32 {
        return withUnsafeBytes { $0.pointee }
    }
}

extension Array where Element == UInt8 {
    var data: Data { return Data(self) }
}

