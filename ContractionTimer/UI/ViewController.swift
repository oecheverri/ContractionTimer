//
//  ViewController.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-07.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ContractionListener {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var contractionButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var timer: Timer?
    var contractionTimer: ContractionTimer?
    
    var isContracting = false {
        didSet {
            contractionButton.setTitle( isContracting ? NSLocalizedString("End", comment: "The end of a contraction has been reached") : NSLocalizedString("Start", comment: "The start of a contraction has been reached"), for: .normal)
            
            cancelButton.isHidden = !isContracting
            
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

    override func viewDidLoad() {
        super.viewDidLoad()
        contractionTimer = ContractionTimer(listeningWith: self)
        UpdateLabels()
        timer = Timer.scheduledTimer(withTimeInterval: 0.042, repeats: true) { _ in
            self.UpdateLabels()
        }
        isContracting = contractionTimer?.isContracting ?? false
    }
    @IBAction func onCanceButtonPushed(_ sender: UIButton) {
        contractionTimer?.cancelContraction()
        tableView.reloadData()
    }
    
    @IBAction func OnContractionButtonClicked(_ sender: Any) {
        contractionTimer?.toggle()
        tableView.reloadData()
    }
    
    func UpdateLabels() {
        if isContracting {
            timerLabel.text = contractionTimer!.lengthOfCurrentContraction.DisplayableString()
        } else {
            timerLabel.text = contractionTimer!.timeSinceEndOfLastContraction.DisplayableString()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath) as! StatViewTableCell
        let currentStat = contractionTimer!.statistics[indexPath.row]
        let value = contractionTimer!.getValue(forStatistic: currentStat)
        cell.set(title: currentStat.localizedName, value: value)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contractionTimer?.statistics.count ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.backgroundColor = UIColor.black
        self.tableView.backgroundColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.view.backgroundColor = UIColor.black
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let statCell = cell as! StatViewTableCell
        
        statCell.backgroundColor = UIColor.black
        statCell.titleLabel.textColor = UIColor.white
        statCell.valueLabel.textColor = UIColor.white
        cell.backgroundColor = UIColor.black
    }
    
}
