import UIKit

protocol ConnectionsDataPassing {
//    var routeModel: RouteModelProtocol? { get set }
}

class ConnectionsRouter: NSObject, ConnectionsDataPassing {
    
    weak var viewController: ConnectionsViewController?
//    var routeModel: RouteModelProtocol?
    
    init(viewController: ConnectionsViewController) {
        self.viewController = viewController
    }
    
    // MARK: Routing
//    func navigateToSignUp(source: ConnectionsViewController, destination: SomeViewController) {
//        source.navigationController?.pushViewController(destination, animated: true)
//    }
}

//extension ConnectionsRouter: ConnectionsRouterProtocol {
////    func routeToSignUp(segue: UIStoryboardSegue?) {
////        //Segue
//////        guard let toVc = segue?.destination as? SomeViewController,
//////            let toEventHandler = toVc.eventHandler as? SomePresenter,
//////            let routeModel = routeModel as? SomeRouteModel else {
//////                print("Error: Could not segue to SomeViewController")
//////                return
//////        }
//////
//////        print("Route: From Main to SomeViewController")
//////
//////        let router = SomeRouter(viewController: toVc)
//////        toEventHandler.router = router
//////        toEventHandler.setRouteModel(model: routeModel)
////
////        //Routing
//////        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//////
//////        guard let fromVc = viewController as? ConnectionsViewController,
//////            let toVc = storyboard.instantiateViewController(withIdentifier: "SomeViewController") as? SomeViewController,
//////            let toEventHandler = toVc.eventHandler as? SomePresenter else {
//////                assertionFailure("Could not instantiate rootViewController")
//////                return
//////        }
//////
//////        let router = SomeRouter(viewController: toVc)
//////        toEventHandler.router = router
//////
//////        navigateToSignUp(source: fromVc, destination: toVc)
////    }
//}

