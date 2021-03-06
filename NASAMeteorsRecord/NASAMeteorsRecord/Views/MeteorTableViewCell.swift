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
            massLabel.text = "Mass: \(model.mass ?? "not available in Json")"
            yearLabel.text = "Year: \(model.year ?? "-")"

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

    static func nibName() -> String {
        return String(describing:self)
    }
    
}
