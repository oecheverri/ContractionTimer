//
//  ContractionTableViewCell.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-08-07.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class ContractionTableViewCell: UITableViewCell {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    
    var start: String = "" {
        didSet {
            startLabel.text = NSLocalizedString("Start: \(start)", comment: "Start time of contraction")
        }
    }
    
    var end: String = "" {
        didSet {
            endLabel.text = NSLocalizedString("End: \(end)", comment: "End time of contraction")
        }
    }
    
    var duration: String = "" {
        didSet {
            durationLabel.text = NSLocalizedString("Duration: \(duration)", comment: "Duration of contraction")
        }
    }
    
    var intensity: String = "" {
        didSet {
            intensityLabel.text = NSLocalizedString("Intensity: \(intensity)", comment: "Intensity of contraction")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
