import UIKit

class BreedTableViewCell: UITableViewCell {

    @IBOutlet private var breedLabel: UILabel!
    
    func setup(breedName: String) {
        breedLabel.text = breedName
    }
}
