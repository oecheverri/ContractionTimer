//
//  ContractionPriv+CoreDataClass.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-15.
//  Copyright © 2019 FoxNet. All rights reserved.
//
//

import Foundation
import CoreData
import os.log

@objc(ContractionPriv)
public class ContractionPriv: NSManagedObject {
    class func CreatePriv(start: NSDate, end: NSDate, intensity: Double) -> ContractionPriv {
        let context = DataManager.shared.backgroundContext
        var contractionPriv: ContractionPriv?
        context.performAndWait {
            let priv = ContractionPriv(context: context)
            priv.start = start
            priv.end = end
            priv.intensity = intensity
            
            do {
                try context.save()
            } catch {
                os_log(.error, log: OSLog.data, "Error saving ContractionPriv: %{public}@", error.localizedDescription)
            }
            contractionPriv = priv
        }
        
        return contractionPriv!
    }
}
