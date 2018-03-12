import Foundation

class ConnectionsEntityGateway {
    weak var interactor: ConnectionsInteractorProtocol?
//    lazy var storage = AppStorage.self
//    lazy var config = AppContext.configuration

    init(interactor: ConnectionsInteractorProtocol) {
        self.interactor = interactor
    }
}

extension ConnectionsEntityGateway: ConnectionsEntityGatewayProtocol {
    
}
