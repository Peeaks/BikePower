import Foundation

class MainEntityGateway {
    weak var interactor: MainInteractorProtocol?
    lazy var storage = AppContext.storage

    init(interactor: MainInteractorProtocol) {
        self.interactor = interactor
    }
}

extension MainEntityGateway: MainEntityGatewayProtocol {
    func readFtp() -> Int {
        guard let ftp = storage?.ftp else {
            return 130
        }
        if ftp == 0 {
            return 130
        }
        return ftp
    }
}
