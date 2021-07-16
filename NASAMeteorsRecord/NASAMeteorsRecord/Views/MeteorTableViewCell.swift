//
//  MeteorTableViewCell.swift
//  NASAMeteorsRecord
//
//  Created by Ankush Kushwaha on 7/16/21.
//

import UIKit

class MeteorTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var massLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!

    var model: MeteorViewModel! {
        didSet {
            nameLabel.text = model.name ?? "-"
            massLabel.text = model.mass ?? "Mass is not available in API"
            yearLabel.text = model.year ?? "-"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nibName() -> String {
        return String(describing:self)
    }
    
}
