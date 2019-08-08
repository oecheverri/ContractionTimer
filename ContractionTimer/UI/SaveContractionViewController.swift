//
//  SaveContractionViewController.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-27.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import UIKit

class SaveContractionViewController: UIViewController {

    var contractionTimer = ContractionTimer.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var intensitySlider: UISlider!
    
    @IBOutlet weak var intensityLabel: UILabel!
    
    @IBAction func onIntensityValueChanged(_ sender: UISlider) {
    
        intensityLabel.text = String(round(sender.value * 10)/10)
    }

    @IBAction func onSaveButtonPushed(_ sender: Any) {
        let currentContraction = contractionTimer.latestContraction!
        currentContraction.intensity = Double(intensitySlider.value)
        contractionTimer.toggle()
        self.dismiss(animated: true)
    }
    @IBAction func onCanceButtonPushed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
