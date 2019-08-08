//
//  ContractionTableViewCell.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-08-07.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class ContractionTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var intensityLabel: UILabel!
    
    let timeFormatter = DateFormatter()
    let dateFormatter = DateFormatter()
    
/*let dateFormatter = DateFormatter()
 dateFormatter.setLocalizedDateFormatFromTemplate("dd-MMM @ hh:mm:ss")
 
 cell.start = dateFormatter.string(from: contraction.start)
 cell.intensity = String(round(contraction.intensity * 10)/10)
 
 if contraction.end == Date.distantFuture {
 cell.end = NSLocalizedString("Current Contraction", comment: "Current Contraction")
 cell.duration = NSLocalizedString("N/A", comment: "Not applicable abbrevation")
 } else {
 cell.end = dateFormatter.string(from: contraction.end)
 cell.duration = contraction.end.timeIntervalSince(contraction.start).DisplayableString()
 }*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateFormatter.setLocalizedDateFormatFromTemplate("dd-MMMM-YYY")
        timeFormatter.setLocalizedDateFormatFromTemplate("hh::mm:ss")
    }
    
    var contraction: Contraction? {
        didSet {
            startLabel.text = NSLocalizedString("Start: \(timeFormatter.string(from: contraction!.start))", comment: "Start time of contraction")
            dateLabel.text = NSLocalizedString("Date: \(dateFormatter.string(from: contraction!.start))", comment: "Date of start of contraction")
            if contraction!.end != Date.distantFuture {
                
                endLabel.text = NSLocalizedString("End: \(timeFormatter.string(from: contraction!.end))", comment: "End time of contraction")
                let duration = contraction!.end.timeIntervalSince(contraction!.start)
                durationLabel.isHidden = false
                durationLabel.text = NSLocalizedString("Duration: \(duration.DisplayableString())", comment: "Duration of contraction")
                intensityLabel.isHidden = false
                
                intensityLabel.text = NSLocalizedString("Intensity: \(String(round(contraction!.intensity * 10)/10))", comment: "Intensity of contraction")
            } else {
                endLabel.text = NSLocalizedString("Current Contraction", comment: "Current Contraction")
                durationLabel.isHidden = true
                intensityLabel.isHidden = true
            }
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
