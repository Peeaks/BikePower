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
        let powerPercentOfFtp = power == -1 ? -1 : Int(Double(power) / Double(self.ftp) * 100)
        
        let powerPercentOfFtpString = powerPercentOfFtp == -1 ? "--" : String("\(powerPercentOfFtp)")
        let heartRateString = heartRate == -1 ? "--" : String(heartRate)
        let powerString = power == -1 ? "--" : String(power)
        let cadenceString = cadence == -1 ? "--" : String(cadence)
        let speedString = speed == -1 ? "--" : String(speed)
        
        let powerZone = calculatePowerZone(powerPercentOfFtp: powerPercentOfFtp)
        
        let viewModel = MainViewModel(powerPercentOfFtp: powerPercentOfFtpString, powerZone: powerZone, heartRate: heartRateString, power: powerString, cadence: cadenceString, speed: speedString)
        viewController?.viewModel = viewModel
    }
    
    func calculatePowerZone(powerPercentOfFtp: Int) -> Int {
        if powerPercentOfFtp <= 55 {
            return 1
        } else if powerPercentOfFtp <= 76 {
            return 2
        } else if powerPercentOfFtp <= 82 {
            return 3
        } else if powerPercentOfFtp <= 90 {
            return 4
        } else {
            return 5
        }
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

