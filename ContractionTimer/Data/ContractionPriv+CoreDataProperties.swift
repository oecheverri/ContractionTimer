//
//  ContractionPriv+CoreDataProperties.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-15.
//  Copyright © 2019 FoxNet. All rights reserved.
//
//

import Foundation
import CoreData


extension ContractionPriv {

    @NSManaged public var end: NSDate
    @NSManaged public var intensity: Double
    @NSManaged public var start: NSDate

}
