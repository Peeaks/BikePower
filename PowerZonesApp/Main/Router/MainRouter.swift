import UIKit

protocol MainDataPassing {
//    var routeModel: RouteModelProtocol? { get set }
}

class MainRouter: NSObject, MainDataPassing {
    
    weak var viewController: MainViewController?
//    var routeModel: RouteModelProtocol?
    
    init(viewController: MainViewController) {
        self.viewController = viewController
    }
    
    // MARK: Routing
//    func navigateToSignUp(source: MainViewController, destination: SomeViewController) {
//        source.navigationController?.pushViewController(destination, animated: true)
//    }
}

extension MainRouter: MainRouterProtocol {
//    func routeToSignUp(segue: UIStoryboardSegue?) {
//        //Segue
////        guard let toVc = segue?.destination as? SomeViewController,
////            let toEventHandler = toVc.eventHandler as? SomePresenter,
////            let routeModel = routeModel as? SomeRouteModel else {
////                print("Error: Could not segue to SomeViewController")
////                return
////        }
////
////        print("Route: From Main to SomeViewController")
////
////        let router = SomeRouter(viewController: toVc)
////        toEventHandler.router = router
////        toEventHandler.setRouteModel(model: routeModel)
//
//        //Routing
////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
////
////        guard let fromVc = viewController as? MainViewController,
////            let toVc = storyboard.instantiateViewController(withIdentifier: "SomeViewController") as? SomeViewController,
////            let toEventHandler = toVc.eventHandler as? SomePresenter else {
////                assertionFailure("Could not instantiate rootViewController")
////                return
////        }
////
////        let router = SomeRouter(viewController: toVc)
////        toEventHandler.router = router
////
////        navigateToSignUp(source: fromVc, destination: toVc)
//    }
}

