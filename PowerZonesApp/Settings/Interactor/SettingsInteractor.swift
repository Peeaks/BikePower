import Foundation

class SettingsInteractor {
    
    weak var presenter: SettingsPresenterProtocol?
    lazy var entityGateway: SettingsEntityGatewayProtocol = SettingsEntityGateway(interactor: self)
    
    init(presenter: SettingsPresenterProtocol) {
        self.presenter = presenter
    }

}

extension SettingsInteractor: SettingsInteractorProtocol {
    
    //In
    func readFtp() -> Int {
        return entityGateway.readFtp()
    }
    
    func readMaxHR() -> Int {
        return entityGateway.readMaxHR()
    }
    
    func ftpPicked(ftp: Int) {
        entityGateway.setFtp(ftp: ftp)
    }
    
    func maxHRPicked(maxHR: Int) {
        entityGateway.setMaxHR(maxHR: maxHR)
    }
    
    //Out
    func presentFtp(ftp: Int) {
        presenter?.presentFtp(ftp: ftp)
    }
    
    func presentMaxHR(maxHR: Int) {
        presenter?.presentMaxHR(maxHR: maxHR)
    }
}
