import UIKit

class SettingsPresenter {
    weak var viewController: SettingsViewControllerProtocol?
    lazy var interactor: SettingsInteractorProtocol = SettingsInteractor(presenter: self)
    var router: (NSObjectProtocol & SettingsRouterProtocol & SettingsDataPassing)?
    
    var ftp: Int = 0
    var maxHR: Int = 0

//    var routeModel: RouteModelProtocol?
    
    init(viewController: SettingsViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func refreshViewModel() {
        let viewModel = SettingsViewModel(ftp: ftp, maxHR: maxHR)
        viewController?.viewModel = viewModel
    }
    
//    func setRouteModel(model: SettingsRouteModel) {
////        self.routeModel = model
//
//        //Pass stuff to ViewModel from another VC
//        let viewModel = SettingsViewModel()
//        viewController?.viewModel = viewModel
//    }
}

extension SettingsPresenter: SettingsEventHandlerProtocol {
    func didLoad() {
        ftp = interactor.readFtp()
        maxHR = interactor.readMaxHR()
        
        refreshViewModel()
    }
    
    func ftpPicked(ftp: Int) {
        interactor.ftpPicked(ftp: ftp)
    }
    
    func maxHRPicked(maxHR: Int) {
        interactor.maxHRPicked(maxHR: maxHR)
    }

    func prepare(for segue: UIStoryboardSegue) {
//        if let scene = segue.identifier {
//            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
//            if let router = router, router.responds(to: selector) {
//                router.perform(selector, with: segue)
//            }
//        }
    }
}

extension SettingsPresenter: SettingsPresenterProtocol {
    //Present something from the interactor
    func presentFtp(ftp: Int) {
        self.ftp = ftp
        refreshViewModel()
    }
    
    func presentMaxHR(maxHR: Int) {
        self.maxHR = maxHR
        refreshViewModel()
    }
}

