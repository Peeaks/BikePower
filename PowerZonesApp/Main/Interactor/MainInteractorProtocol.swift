import Foundation

protocol MainInteractorProtocol: class {

    //In
    func didLoad()
    func readFtp() -> Int

    //Out
    func presentHeartRate(heartRate: Int)
    func presentPower(power: PowerData)

}
