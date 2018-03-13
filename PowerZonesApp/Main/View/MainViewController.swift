import UIKit

class MainViewController: UIViewController {
    
    lazy var eventHandler: MainEventHandlerProtocol = MainPresenter(viewController: self)
    
    var viewModel: MainViewModel? {
        didSet {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintAdjustmentMode = .normal
        self.navigationController?.navigationBar.tintAdjustmentMode = .automatic
        
        self.eventHandler.viewWillAppear()
    }
    
    // MARK: Interface Builder Outlets
    @IBOutlet weak var powerZoneImage: UIImageView!
    @IBOutlet weak var powerPercentOfFtpLabel: UILabel!
    @IBOutlet weak var powerLabel: UILabel!
    @IBOutlet weak var heartRateLabel: UILabel!
    @IBOutlet weak var cadenceLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    
    // MARK: Interface Builder Actions
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        eventHandler.prepare(for: segue)
    }
}

extension MainViewController {
    func refresh() {
        assert(Thread.isMainThread)
        //Do something
        
        guard let viewModel = self.viewModel else { return }
        
        powerPercentOfFtpLabel.text = viewModel.powerPercentOfFtp
        powerLabel.text = viewModel.power
        heartRateLabel.text = viewModel.heartRate
        cadenceLabel.text = viewModel.cadence
        speedLabel.text = viewModel.speed
        
        switch viewModel.powerZone {
        case 1:
            powerZoneImage.image = UIImage(named: "bigWhiteCircle")
        case 2:
            powerZoneImage.image = UIImage(named: "bigBlueCircle")
        case 3:
            powerZoneImage.image = UIImage(named: "bigGreenCircle")
        case 4:
            powerZoneImage.image = UIImage(named: "bigYellowCircle")
        case 5:
            powerZoneImage.image = UIImage(named: "bigRedCircle")
        default:
            powerZoneImage.image = UIImage(named: "bigWhiteCircle")
        }
    }
}

extension MainViewController: MainViewControllerProtocol {

}
