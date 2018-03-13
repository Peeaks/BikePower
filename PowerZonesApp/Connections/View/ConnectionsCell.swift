import Foundation
import UIKit

class ConnectionsCell: UITableViewCell {
    
    @IBOutlet weak var typeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var checkmarkImage: UIImageView!
    
    func setupCell(cellViewModel: ConnectionsCellViewModel) {
        nameLabel.text = cellViewModel.name
        
        switch cellViewModel.type {
        case .HR:
            typeImage.image = UIImage(named: "heartIcon")
        case .PWR:
            typeImage.image = UIImage(named: "powerIcon")
        }
        
        if cellViewModel.active {
            checkmarkImage.isHidden = false
        } else {
            checkmarkImage.isHidden = true
        }
    }
}

enum DeviceType {
    case HR
    case PWR
}
