//
//  Logger.swift
//  ContractionTimer
//
//  Created by Oscar Echeverri on 2019-07-09.
//  Copyright © 2019 FoxNet. All rights reserved.
//
import Foundation
import os.log


extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    static let views = OSLog(subsystem: subsystem, category: "view")
    static let data = OSLog(subsystem: subsystem, category: "data")
    static let model = OSLog(subsystem: subsystem, category: "model")
}
