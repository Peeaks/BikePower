import Foundation
import UIKit

class ConnectionsCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    
    func setupCell(cellViewModel: ConnectionsCellViewModel) {
        nameLabel.text = cellViewModel.name
        typeLabel.text = cellViewModel.type
    }
    
}
