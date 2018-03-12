import Foundation

protocol MainPresenterProtocol: class {
    func presentHeartRate(heartRate: Int)
    func presentPower(powerData: PowerData)
}
