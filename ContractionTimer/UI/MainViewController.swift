//
//  ViewController.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-07.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContractionListener {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var contractionButtons: UIStackView!
    @IBOutlet weak var startContractionButton: UIButton!
    @IBOutlet weak var stopContractionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer?
    var contractionTimer = ContractionTimer.shared
    
    var isContracting = false {
        didSet {
            titleLabel.text = isContracting ? NSLocalizedString("Current Contraction", comment: "Current contraction") : NSLocalizedString("Since Last Contraction", comment: "Time since last contraction")
            startContractionButton.isHidden = isContracting
            contractionButtons.isHidden = !isContracting
            
            if isContracting {
                let pulseAnimation = CABasicAnimation(keyPath: "opacity")
                pulseAnimation.duration = 1.5
                pulseAnimation.fromValue = 0.25
                pulseAnimation.toValue = 1
                pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                pulseAnimation.autoreverses = true
                pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
                
                titleLabel.layer.add(pulseAnimation, forKey: nil)
            } else {
                titleLabel.layer.removeAllAnimations()
            }
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startContractionButton.setTitle(NSLocalizedString("Start", comment: "The start of a contraction has been reached"), for: .normal)
        stopContractionButton.setTitle(NSLocalizedString("Stop", comment: "Stop the timer for this contraction"), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel the current Contraction"), for: .normal)
        contractionTimer.contractionListener = self
        UpdateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 0.042, repeats: true) { _ in
            self.UpdateLabels()
        }
        isContracting = contractionTimer.isContracting
    }
    @IBAction func onCancelButtonPushed(_ sender: UIButton) {
        contractionTimer.cancelContraction()
    }
    
    @IBAction func onStartButtonPushed(_ sender: Any) {
        contractionTimer.toggle()
    }
    
    func UpdateLabels() {
        if isContracting {
            if let lengthOfCurrentContraction = contractionTimer.lengthOfCurrentContraction {
                timerLabel.text = lengthOfCurrentContraction.DisplayableString()
            } else {
                timerLabel.text = 0.0.DisplayableString()
            }
        } else {
            timerLabel.text = contractionTimer.timeSinceEndOfLastContraction.DisplayableString()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatViewTableCell
        let currentStat = contractionTimer.statistics[indexPath.row]
        let value = contractionTimer.getValue(forStatistic: currentStat)
        cell.set(title: currentStat.localizedName, value: value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractionTimer.statistics.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.view.backgroundColor = UIColor.black
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let statCell = cell as! StatViewTableCell
        
        statCell.backgroundColor = UIColor.black
        statCell.titleLabel.textColor = UIColor.white
        statCell.valueLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
    }
    
}
