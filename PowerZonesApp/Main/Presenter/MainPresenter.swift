import UIKit

class MainPresenter {
    weak var viewController: MainViewControllerProtocol?
    lazy var interactor: MainInteractorProtocol = MainInteractor(presenter: self)
    var router: (NSObjectProtocol & MainRouterProtocol & MainDataPassing)?

//    var routeModel: RouteModelProtocol?
    
    var ftp: Int = 0
    
    var heartRate: Int = -1
    var power: Int = -1
    var cadence: Int = -1
    var speed: Int = -1
    
    init(viewController: MainViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func refreshViewModel() {
        let powerPercentOfFtpString = power == -1 ? "--" : String("\(Int(Double(power) / Double(self.ftp) * 100)) %")
        let heartRateString = heartRate == -1 ? "--" : String(heartRate)
        let powerString = power == -1 ? "--" : String(power)
        let cadenceString = cadence == -1 ? "--" : String(cadence)
        let speedString = speed == -1 ? "--" : String(speed)
        
        let viewModel = MainViewModel(powerPercentOfFtp: powerPercentOfFtpString, heartRate: heartRateString, power: powerString, cadence: cadenceString, speed: speedString)
        viewController?.viewModel = viewModel
    }
}

extension MainPresenter: MainEventHandlerProtocol {
    func viewDidLoad() {
        interactor.didLoad()
    }
    
    func viewWillAppear() {
        self.ftp = interactor.readFtp()
    }
}

extension MainPresenter: MainPresenterProtocol {
    //Present something from the interactor
    func presentHeartRate(heartRate: Int) {
        self.heartRate = heartRate
        refreshViewModel()
    }
    
    func presentPower(powerData: PowerData) {
        self.power = powerData.power
        self.cadence = powerData.cadence == nil ? -1 : Int(powerData.cadence!)
        self.speed = powerData.distanceInMeters == nil ? -1 : Int(powerData.speedInMetersPerSecond! * 3.6)
        refreshViewModel()
    }
}

