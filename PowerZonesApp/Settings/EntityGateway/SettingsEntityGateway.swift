import Foundation

class SettingsEntityGateway {
    weak var interactor: SettingsInteractorProtocol?
    lazy var storage = AppContext.storage

    init(interactor: SettingsInteractorProtocol) {
        self.interactor = interactor
    }
}

extension SettingsEntityGateway: SettingsEntityGatewayProtocol {
    func readFtp() -> Int {
        guard let ftp = storage?.ftp else {
            return 130
        }
        if ftp == 0 {
            return 130
        }
        return ftp
    }
    
    func readMaxHR() -> Int {
        guard let maxHR = storage?.maxHR else {
            return 200
        }
        if maxHR == 0 {
            return 200
        }
        return maxHR
    }
    
    func setFtp(ftp: Int) {
        storage?.ftp = ftp
        interactor?.presentFtp(ftp: ftp)
    }
    
    func setMaxHR(maxHR: Int) {
        storage?.maxHR = maxHR
        interactor?.presentMaxHR(maxHR: maxHR)
    }
    
}
