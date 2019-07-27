//
//  ContractionTimer.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-08.
//  Copyright © 2019 FoxNet. All rights reserved.
//

import Foundation
import CoreData
import os.log

class ContractionTimer {
    
    enum Statistics: CaseIterable {
        case AverageDuration
        case ContractionPeriod
        case LastContractionLength
        case NumberOfContractions
        
        var localizedName: String {
            switch self {
            case .AverageDuration:
                return NSLocalizedString("Average Length", comment: "Length of average contraction")
            case .ContractionPeriod:
                return NSLocalizedString("Time Between", comment: "Length of time between the start if contraction")
            case .LastContractionLength:
                return NSLocalizedString("Last Contraction", comment: "THe length of the last contraction")
            case .NumberOfContractions:
                return NSLocalizedString("Total Contractions", comment: "The current number of contractions")
            }
        }
    }
    var latestContraction: Contraction? = nil
    var statistics: [Statistics] {
        return Statistics.allCases
    }
    var contractionListener: ContractionListener
    
    init(listeningWith contractionListener: ContractionListener) {
        self.contractionListener = contractionListener
        let contractions = Contraction.getContractions()
        if !contractions.isEmpty {
            latestContraction = contractions[0]
        }
    }
    
    var lastContractionStartTime: Date {
        return latestContraction?.start ?? Date.distantPast
    }
    
    var lengthOfPreviousContraction: TimeInterval {
        if isContracting {
            let contractions = Contraction.getContractions()
            if contractions.count > 1 {
                return contractions[contractions.count - 2].length
            } else {
                return 0
            }
        } else {
            return lengthOfCurrentContraction
        }
    }
    var lengthOfCurrentContraction: TimeInterval {
        if let latestContraction = self.latestContraction {
            if latestContraction.end == Date.distantFuture {
                return Date().timeIntervalSince(latestContraction.start)
            } else {
                return latestContraction.end.timeIntervalSince(latestContraction.start)
            }
        } else {
            return 0
        }
    }
    
    var timeSinceEndOfLastContraction: TimeInterval {
        if latestContraction != nil && latestContraction!.end != Date.distantFuture {
            return Date().timeIntervalSince(latestContraction!.end)
        } else {
            return 0
        }
    }
    
    var isContracting: Bool {
        return latestContraction != nil && latestContraction?.end == Date.distantFuture
    }
    
    func toggle() {
        if latestContraction == nil || latestContraction?.end != Date.distantFuture {
            latestContraction = Contraction(startTime: Date(), length: 0, intensity: 0)
            latestContraction?.end = Date.distantFuture
        } else {
            latestContraction?.end = Date()
        }
        contractionListener.isContracting = isContracting
    }
    
    func getValue(forStatistic statistic: Statistics) -> String {
        switch (statistic) {
        case .AverageDuration:
            return Contraction.averageContractionLengthOver(last: 1, units: .hour).DisplayableString()
        case .LastContractionLength:
            return lengthOfPreviousContraction.DisplayableString()
        case .ContractionPeriod:
            let contractionIntervals = Contraction.averageContractionPeriodOver(last: 1, units: .hour)
            return contractionIntervals.DisplayableString()
        case .NumberOfContractions:
            return String(Contraction.getContractions().count)
        }
    }
    
    func cancelContraction() {
        if isContracting {
            Contraction.delete(contraction: latestContraction!)
            let allContractions = Contraction.getContractions()
            
            if !allContractions.isEmpty {
                latestContraction = allContractions[0]
            } else {
                latestContraction = nil
            }
            
            contractionListener.isContracting = isContracting
        }
    }
    
}

protocol ContractionListener {
    var isContracting: Bool {get set}
}

extension TimeInterval {
    enum TimeUnits: TimeInterval {
        case second = 1.0
        case minute = 60.0
        case quarterHour = 900.0
        case halfHour = 1800.0
        case hour = 3600.0
    }
    
    func truncate(places : Int)-> Double
    {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
    func DisplayableString() -> String {
        let minutes = Int(self / 60)
        let seconds = Int(self - (TimeInterval(minutes) * 60))
        let milliseconds = Int((self.truncate(places: 3) - (TimeInterval(minutes) * 60) - TimeInterval(seconds)) * 1000)
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
