import Foundation

protocol ConnectionsInteractorProtocol: class {

    //In
    func didLoad()
    func didDisappear()
    
    func didSelectRowAt(indexPath: IndexPath)

    //Out
    func presentPeripherals()

}
