//
//  MeteorTableViewCell.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit

protocol MeteorTableViewCellDelegate: class {
    func favouriteButtonClicked(model: MeteorViewModel)
}

class MeteorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var favouriteButton: UIButton!

    weak var delegate: MeteorTableViewCellDelegate?

    var model: MeteorViewModel! {
        didSet {
            nameLabel.text = model.name ?? "-"
            massLabel.text = model.mass ?? "Mass is not available in API"
            yearLabel.text = model.year ?? "-"

            if model.isFavourite {
                favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)

            }
        }
    }

    @IBAction func favouriteButtonAction() {
        delegate?.favouriteButtonClicked(model: model)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nibName() -> String {
        return String(describing:self)
    }
    
}
