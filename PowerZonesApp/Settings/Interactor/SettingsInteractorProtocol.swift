import Foundation

protocol SettingsInteractorProtocol: class {

    //In
    func readFtp() -> Int
    func readMaxHR() -> Int
    
    func ftpPicked(ftp: Int)
    func maxHRPicked(maxHR: Int)

    //Out
    func presentFtp(ftp: Int)
    func presentMaxHR(maxHR: Int)
}
