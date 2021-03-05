//
//  Logger.swift
//  SwiftLogger
//
//  Created by Sauvik Dolui on 03/05/2017.
//  Copyright © 2016 Innofied Solutions Pvt. Ltd. All rights reserved.
//

import Foundation

class Logger {
    
    // Enum for showing the type of Log Types
    enum Event: String {
        case error      = "[‼️]"
        case info       = "[ℹ️]"
        case debug      = "[💬]"
        case verbose    = "[🔬]"
        case warning    = "[⚠️]"
        case severe     = "[🔥]"
    }
    
    static let dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    class func log(message: String, event: Event, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
        #if DEBUG
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: fileName))]:\(line) \(column) \(funcName) -> \(message)")
        #endif
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return Logger.dateFormatter.string(from: self as Date)
    }
}

func logIN(fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: "IN", event: .debug, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logOUT(fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: "OUT", event: .debug, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logError(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .error, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logInfo(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .info, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logDebug(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .debug, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logVerbose(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .verbose, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logWarning(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .warning, fileName: fileName, line: line, column: column, funcName: funcName)
}

func logSevere(_ message: String, fileName: String = #file, line: Int = #line, column: Int = #column, funcName: String = #function) {
    Logger.log(message: message, event: .severe, fileName: fileName, line: line, column: column, funcName: funcName)
}
