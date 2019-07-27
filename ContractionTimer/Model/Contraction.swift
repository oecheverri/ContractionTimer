//
//  Contraction.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-10.
//  Copyright © 2019 FoxNet. All rights reserved.
//
import CoreData
import os.log

class Contraction {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContractionPriv> {
        return NSFetchRequest<ContractionPriv>(entityName: "Contraction")
    }
    
    var priv: ContractionPriv
    var start: Date {
        didSet {
            let context = DataManager.shared.backgroundContext
            context.perform {
                self.priv.start = self.start as NSDate
            }
        }
    }
    
    var end: Date {
        didSet {
            let context = DataManager.shared.backgroundContext
            context.perform {
                self.priv.end = self.end as NSDate
            }
        }
    }
    
    var intensity: Double {
        didSet {
            let context = DataManager.shared.backgroundContext
            context.perform {
                self.priv.intensity = self.intensity
            }
        }
    }
    
    var length: TimeInterval {
        return end.timeIntervalSince(start)
    }
    
    init(startTime: Date, length: TimeInterval, intensity: Double) {
        priv = ContractionPriv.CreatePriv(start: startTime as NSDate, end: startTime.addingTimeInterval(length) as NSDate, intensity: intensity)
        start = startTime
        end = startTime.addingTimeInterval(length)
        self.intensity = intensity
    }
    
    init(contractionPriv: ContractionPriv) {
        priv = contractionPriv
        start = contractionPriv.start as Date
        end = contractionPriv.end as Date
        intensity = contractionPriv.intensity
    }
    
    class func getContractionStartDates() -> [Date] {
        var dates = [Date]()
        let context = DataManager.shared.backgroundContext
        context.performAndWait {
            let fetchRequest: NSFetchRequest<ContractionPriv> = Contraction.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "start", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]    
            do {
                let results = try fetchRequest.execute()
                for contraction in results {
                    dates.append(contraction.start as Date)
                }
            } catch {
                os_log(.error, log: OSLog.data, "Failed to retrieve contraction start dates")
            }
            
        }
        return dates
    }
    
    class func getContractions(start: Date, interval: TimeInterval) -> [Contraction] {
        
        let endDate = start.addingTimeInterval(interval)
        let predicate = NSPredicate(format: "start < %@ && start < %@", start as NSDate, endDate as NSDate)
        let contractions = getContractions(with: predicate)
        
        return contractions
    }
    
    class func getContractions() -> [Contraction] {
        return getContractions(with: nil)
    }
    
    private class func getContractions(with predicate: NSPredicate?) -> [Contraction]{
        var contractions = [Contraction]()
        let context = DataManager.shared.backgroundContext
        context.performAndWait {
            let fetchRequest = Contraction.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "start", ascending: true)
            fetchRequest.predicate = predicate
            fetchRequest.sortDescriptors = [sortDescriptor]
            do {
                let result = try fetchRequest.execute()
                for contractionPriv in result {
                    contractions.append(Contraction(contractionPriv: contractionPriv))
                }
            } catch {
                os_log(.error, log: OSLog.data, "Failed to retrieve contraction start dates")
            }
        }
        return contractions
    }
    
    class func averageContractionLengthOver(last scalar: Double, units: TimeInterval.TimeUnits) -> TimeInterval {
        let startDate = Date()
        let total: TimeInterval = units.rawValue * scalar
        
        let contractions = getContractions(start: startDate, interval: total)
        
        if contractions.isEmpty {
            return 0
        } else {
            var totalLength: TimeInterval = 0.0
            var countedContractions = 0
            contractions.forEach  { (contraction) in
                if (contraction.end != Date.distantFuture) {
                    totalLength += contraction.length
                    countedContractions += 1
                }
            }
            let averageLength = countedContractions > 0 ? totalLength / Double(countedContractions) : 0
            return averageLength
        }
    }
    
    class func averageContractionPeriodOver(last scalar: Double, units: TimeInterval.TimeUnits) -> TimeInterval {
        let startDate = Date()
        let total: TimeInterval = units.rawValue * scalar
        
        let contractions = getContractions(start: startDate, interval: total)
        var contractionIntervals = [TimeInterval]()
        
        if contractions.isEmpty {
            return 0
        } else {
            
            for (index, currentContraction) in contractions.enumerated() {
                if (contractions.index(after: index) != contractions.endIndex) {
                    let nextContraction = contractions[contractions.index(after: index)]
                    contractionIntervals.append(nextContraction.start.timeIntervalSince(currentContraction.start))
                }
            }
            
            if !contractionIntervals.isEmpty {
                var totalTimeBetween: TimeInterval = 0.0
                contractionIntervals.forEach  { (contractionInterval) in
                    totalTimeBetween += contractionInterval
                }
                let averageInterval = totalTimeBetween / Double(contractionIntervals.count)
                return averageInterval
            } else {
                return 0
            }
        }
    }
    
    class func delete(contraction: Contraction) {
        let backgroundContext = DataManager.shared.backgroundContext
        backgroundContext.performAndWait {
            backgroundContext.delete(contraction.priv)
        }
    }
}

//@objc(ContractionPriv)
//public class ContractionPriv: NSManagedObject {
//    
//    
//    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContractionPriv> {
//        return NSFetchRequest<ContractionPriv>(entityName: "Contraction")
//    }
//    
//    @NSManaged public var end: NSDate
//    @NSManaged public var intensity: Double
//    @NSManaged public var start: NSDate
//}
