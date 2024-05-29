//
//  SmartLog.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/7.
//

import Foundation

public struct SmartConfig {
    
    public enum DebugMode: Int {
        case verbose = 0
        case debug = 1
        case warning = 2
        case none = 3

    }
    
    /// Set debug mode
    public static var debugMode: DebugMode {
        get { return _mode }
        set { _mode = newValue }
    }
    
    /// Set up different levels of padding
    public static var space: String = "   "
    /// Set the markup for the model
    public static var modelSign: String = "|> "
    /// Sets the tag for the property
    public static var attributeSign: String = "|- "
    
    /// Whether to enable assertions (effective in debug mode)
    /// Once enabled, an assertion will be performed where parsing fails, providing a more direct reminder to the user that parsing has failed at this point.
    public static var openErrorAssert: Bool = false
    
    private static var _mode = DebugMode.warning
}


extension SmartLog {
    static func createLog<T>(
        impl: JSONDecoderImpl,
        isOptionalLog: Bool = false,
        forKey key: CodingKey, entry: Any?, type: T.Type) {
        
        // 如果被忽略了，就不要输出log了。
        let typeString = String(describing: T.self)
        guard !typeString.starts(with: "IgnoredKey<") else { return }
        
        let className = impl.cache.topSnapshot?.typeName ?? ""
        var path = impl.codingPath
        path.append(key)
        
        
        
        if let entry = entry {
            if entry is NSNull { // 值为null
                if isOptionalLog { return }
                let error = DecodingError.Keyed._valueNotFound(key: key, expectation: T.self, codingPath: path)
                SmartLog.logDebug(error, className: className)
            } else { // value类型不匹配
                let error = DecodingError._typeMismatch(at: path, expectation: T.self, reality: entry)
                SmartLog.logWarning(error: error, className: className)
            }
        } else { // key不存在或value为nil
            if isOptionalLog { return }
            let error = DecodingError.Keyed._keyNotFound(key: key, codingPath: path)
            SmartLog.logDebug(error, className: className)
        }
    }
}



struct SmartLog {
    
    private static var cache = LogCache()
    
    static func logDebug(_ error: DecodingError, className: String) {
        logIfNeeded(level: .debug) {
            if SmartConfig.openErrorAssert {
                assert(false, "\(error)")
            }
            cache.save(error: error, className: className)
        }
    }
    
    static func logWarning(error: DecodingError, className: String) {
        logIfNeeded(level: .warning) {
            cache.save(error: error, className: className)
        }
    }
    
    static func logVerbose(_ item: String, in className: String) {
        logIfNeeded(level: .verbose) {
            let header = getHeader()
            let footer = getFooter()
            let output = "[\(className)] \(item)\n"
            print("\(header)\(output)\(footer)")
        }
    }
    
    static func printCacheLogs(in name: String) {
        
        guard isAllowCacheLog() else { return }
        
        if let format = cache.formatLogs() {
            var message: String = ""
            message += getHeader()
            message += name + " 👈🏻 👀\n"
            message += format
            message += getFooter()
            print(message)
        }
        
        cache.clearCache()
    }
    
    static func isAllowCacheLog() -> Bool {
        if SmartConfig.debugMode.rawValue >= SmartConfig.DebugMode.verbose.rawValue {
           return true
        }
        return false
    }
}


extension SmartLog {
    
    static func getHeader() -> String {
        return "\n========================  [Smart Decoding Log]  ========================\n"
    }
    
    static func getFooter() -> String {
        return "=========================================================================\n"
    }
    
    private static func logIfNeeded(level: SmartConfig.DebugMode, callback: () -> ()) {
        if SmartConfig.debugMode.rawValue <= level.rawValue {
           callback()
        }
    }
}
