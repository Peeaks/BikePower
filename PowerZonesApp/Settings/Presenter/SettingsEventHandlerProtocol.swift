import Foundation
import UIKit

protocol SettingsEventHandlerProtocol {
    func prepare(for segue: UIStoryboardSegue)
    
    func didLoad()
    
    func ftpPicked(ftp: Int)
    func maxHRPicked(maxHR: Int)
}
