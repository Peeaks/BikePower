import Foundation
import CoreBluetooth

class MainInteractor {
    
    weak var presenter: MainPresenterProtocol?
    lazy var entityGateway: MainEntityGatewayProtocol = MainEntityGateway(interactor: self)
    
    init(presenter: MainPresenterProtocol) {
        self.presenter = presenter
        
        sharedBLEManager.heartRateChanged = presentHeartRate
        sharedBLEManager.powerChanged = presentPower
//        sharedMockBLEManager.heartRateChanged = presentHeartRate
//        sharedMockBLEManager.powerChanged = presentPower
    }

}

extension MainInteractor: MainInteractorProtocol {
    
    //In
    func didLoad() {
//        sharedBLEManager.startScanning()
    }
    
    func readFtp() -> Int {
        return entityGateway.readFtp()
    }
    
    //Out
    func presentHeartRate(heartRate: Int) {
        presenter?.presentHeartRate(heartRate: heartRate)
    }
    
    func presentPower(power powerData: PowerData) {
        presenter?.presentPower(powerData: powerData)
    }
}

