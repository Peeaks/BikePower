import Foundation

protocol SettingsEntityGatewayProtocol {
    
    func readFtp() -> Int
    func readMaxHR() -> Int
    
    func setFtp(ftp: Int)
    func setMaxHR(maxHR: Int)
}
