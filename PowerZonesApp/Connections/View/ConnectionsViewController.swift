import UIKit

class ConnectionsViewController: UIViewController {
    
    lazy var eventHandler: ConnectionsEventHandlerProtocol = ConnectionsPresenter(viewController: self)
    
    var viewModel: ConnectionsViewModel? {
        didSet {
            refresh()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventHandler.didLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        eventHandler.didDisappear()
    }
    
    // MARK: Interface Builder Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Interface Builder Actions
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        eventHandler.prepare(for: segue)
    }
}

extension ConnectionsViewController {
    func refresh() {
        assert(Thread.isMainThread)
        //Do something
        tableView?.reloadData()
    }
}

extension ConnectionsViewController: ConnectionsViewControllerProtocol {
    
}

extension ConnectionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventHandler.didSelectRowAt(indexPath: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

extension ConnectionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else {
            return 0
        }
        
        switch section {
        case 0:
            return viewModel.heartRateCellViewModels.count
        case 1:
            return viewModel.cyclingPowerCellViewModels.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Connected Devices"
        case 1:
            return "Heart Rate Monitors"
        case 2:
            return "Cycling Power Meters"
        default:
            return "Unknown section"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        guard let viewModel = self.viewModel else {
            print("Error: ViewModel not set")
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionsCell", for: indexPath) as? ConnectionsCell else {
            print("Error: Could not instantiate ConnectionsCell")
            return UITableViewCell()
        }
        
        switch (section) {
        case 0:
            // Logic for showing connected devices
            print("Logic for showing connected devices needed")
        case 1:
            cell.setupCell(cellViewModel: viewModel.heartRateCellViewModels[row])
        case 2:
            cell.setupCell(cellViewModel: viewModel.cyclingPowerCellViewModels[row])
        default:
            break
        }
        
        return cell
    }
    
    
}
