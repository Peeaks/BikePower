import UIKit

class SettingsViewController: UIViewController {
    
    lazy var eventHandler: SettingsEventHandlerProtocol = SettingsPresenter(viewController: self)
    
    var viewModel: SettingsViewModel? {
        didSet {
            refresh()
        }
    }
    
    var currentPickerUnit: currentPickerUnit = .unset
    var ftpPicker: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupFtpPicker()
        
        eventHandler.didLoad()
    }
    
    func setupFtpPicker() {
//        ftpPicker = UIPickerView()
        ftpPicker.delegate = self
        ftpPicker.dataSource = self
        ftpTextField.inputView = ftpPicker
        maxHRTextField.inputView = ftpPicker
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneClick))
        toolBar.setItems([flexible, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        ftpTextField.inputAccessoryView = toolBar
        maxHRTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneClick() {
        ftpTextField.resignFirstResponder()
        maxHRTextField.resignFirstResponder()
    }
    
    // MARK: Interface Builder Outlets
    @IBOutlet weak var ftpTextField: UITextField!
    @IBOutlet weak var maxHRTextField: UITextField!
    
    // MARK: Interface Builder Actions
    @IBAction func ftpEditingDidBegin(_ sender: UITextField) {
        currentPickerUnit = .ftp
        
        guard let viewModel = self.viewModel else { return }
        ftpPicker.selectRow(viewModel.ftp - 1, inComponent: 0, animated: false)
    }
    
    @IBAction func maxHREditingDidBegin(_ sender: UITextField) {
        currentPickerUnit = .maxHR
        
        guard let viewModel = self.viewModel else { return }
        ftpPicker.selectRow(viewModel.maxHR - 1, inComponent: 0, animated: false)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        eventHandler.prepare(for: segue)
    }
    
}

extension SettingsViewController {
    func refresh() {
        assert(Thread.isMainThread)
        //Do something
        
        guard let viewModel = self.viewModel else { return }
        
        ftpTextField.text = String("\(viewModel.ftp) W")
        maxHRTextField.text = String("\(viewModel.maxHR) bpm")
    }
}

extension SettingsViewController: SettingsViewControllerProtocol {
    
}

extension SettingsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch currentPickerUnit {
        case .ftp:
            eventHandler.ftpPicked(ftp: row + 1)
        case .maxHR:
            eventHandler.maxHRPicked(maxHR: row + 1)
        default:
            print("Switch went to default value at SettingsViewController didSelectRow")
        }
    }
}

extension SettingsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch currentPickerUnit {
        case .ftp:
            return 1000
        case .maxHR:
            return 250
        default:
            print("Switch went to default value at SettingsViewController numberOfComponents")
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch currentPickerUnit {
        case .ftp:
            return String("\(row + 1) W")
        case .maxHR:
            return String("\(row + 1) bpm")
        default:
            print("Switch went to default value at SettingsViewController titleForRow")
            return "Unknown"
        }
    }
}

enum currentPickerUnit {
    case unset
    case ftp
    case maxHR
}
