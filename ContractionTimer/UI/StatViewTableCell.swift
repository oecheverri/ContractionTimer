//
//  StatViewTableCell.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-15.
//  Copyright © 2019 FoxNet. All rights reserved.
//
import UIKit

class StatViewTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func set(title: String, value: String) {
        titleLabel.text = title
        valueLabel.text = value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
