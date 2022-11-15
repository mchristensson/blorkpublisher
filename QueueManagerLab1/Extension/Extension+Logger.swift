//
//  Extension+Logger.swift
//  QueueManagerLab1
//
//  Created by Magnus Christensson on 2022-11-15.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let general = Logger(subsystem: subsystem, category: "general")
}
