//
//  ContractionTimer.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-08.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import Foundation

class ContractionTimer {
    
    var contractionListener: ContractionListener
    var isContracting = false
    var contractionStartTimes = [Date]()
    var contractionLengths = [TimeInterval]()
    
    var lastContractionStartTime: Date? {
        if contractionStartTimes.isEmpty {
            return nil
        } else {
            return contractionStartTimes[contractionStartTimes.count - 1]
        }
    }
    
    var lengthOfCurrentContraction: TimeInterval {
        if isContracting {
            return Date().timeIntervalSince(lastContractionStartTime!)
        } else {
            return 0
        }
    }
    
    var lengthOfLastContraction: TimeInterval {
        if contractionLengths.isEmpty {
            return 0
        } else {
            return contractionLengths[contractionLengths.count - 1]
        }
    }
    
    var timeSinceLastContraction: TimeInterval {
        if !isContracting && lastContractionStartTime != nil{
            return Date().timeIntervalSince(lastContractionStartTime!.addingTimeInterval(lengthOfLastContraction))
        } else {
            return 0
        }
    }
    
    init(listeningWith contractionListener: ContractionListener) {
        self.contractionListener = contractionListener
    }
    
    func toggle() {
        
        if !isContracting {
            contractionStartTimes.append(Date())
        } else {
            contractionLengths.append(Date().timeIntervalSince(lastContractionStartTime!))
        }
        isContracting = !isContracting
        contractionListener.isContracting = isContracting
    }
    
}

protocol ContractionListener {
    var isContracting: Bool {get set}
}
