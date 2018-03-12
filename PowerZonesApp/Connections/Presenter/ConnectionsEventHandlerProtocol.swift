import Foundation
import UIKit

protocol ConnectionsEventHandlerProtocol {
    func prepare(for segue: UIStoryboardSegue)
    
    func didLoad()
    func didDisappear()
    
    func didSelectRowAt(indexPath: IndexPath)
}
