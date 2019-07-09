//
//  ViewController.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-07.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ContractionListener {
    
    var timer: Timer?
    
    var isContracting = false {
        didSet {
            contractionButton.setTitle( isContracting ? NSLocalizedString("End Contraction", comment: "The end of a contraction has been reached") : NSLocalizedString("Start Contraction", comment: "The start of a contraction has been reached"), for: .normal)
            titleLabel.text = isContracting ? NSLocalizedString("Current Contraction", comment: "Current contraction") : NSLocalizedString("Since Last Contraction", comment: "Time since last contraction")
            
            
            if isContracting {
                let pulseAnimation = CABasicAnimation(keyPath: "opacity")
                pulseAnimation.duration = 1
                pulseAnimation.fromValue = 0
                pulseAnimation.toValue = 1
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
                
                titleLabel.layer.add(pulseAnimation, forKey: nil)
            } else {
                titleLabel.layer.removeAllAnimations()
            }
            
        }
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var contractionButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var contractionTimer: ContractionTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contractionTimer = ContractionTimer(listeningWith: self)
        UpdateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 0.042, repeats: true) { _ in
            self.UpdateLabels()
        }
    }
    
    @IBAction func OnContractionButtonClicked(_ sender: Any) {
        contractionTimer?.toggle()
    }
    
    func UpdateLabels() {
        if isContracting {
            timerLabel.text = CalculateTimerString(for: contractionTimer!.lengthOfCurrentContraction)
        } else {
            timerLabel.text = CalculateTimerString(for: contractionTimer!.timeSinceLastContraction)
        }
    }
    
    func CalculateTimerString(for interval: TimeInterval) -> String {
        let minutes = Int(interval / 60)
        let seconds = Int(interval - (TimeInterval(minutes) * 60))
        let milliseconds = Int((interval.truncate(places: 3) - (TimeInterval(minutes) * 60) - TimeInterval(seconds)) * 1000)
        let minutesString = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secondsString = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let millisecondString: String
        if milliseconds == 0 {
            millisecondString = "000"
        } else if (milliseconds < 10) {
            millisecondString = "00\(milliseconds)"
        } else if (milliseconds < 100) {
            millisecondString = "0\(milliseconds)"
        } else {
            millisecondString = "\(milliseconds)"
        }
        return "\(minutesString):\(secondsString).\(millisecondString)"
    }

}

extension TimeInterval
{
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
