//
//  SmartSentinel.swift
//  BTCodable
//
//  Created by Mccc on 2023/8/7.
//

import Foundation

public struct SmartSentinel {
    
    public enum Level: Int {
        case none
        case verbose
        case alert
    }
    
    /// Set debugging mode, default is none. 
    /// Note: When not debugging, set to none to reduce overhead.
    public static var debugMode: Level {
        get { return _mode }
        set { _mode = newValue }
    }
    
    /// 是否满足日志记录的条件
    public static var isValid: Bool {
        return debugMode != .none

    }
    
    /// Set up different levels of padding
    public static var space: String = "   "
    /// Set the markup for the model
    public static var modelSign: String = "|> "
    /// Sets the tag for the property
    public static var attributeSign: String = "|- "
    
    private static var _mode = Level.none
    
    private static var cache = LogCache()

}


extension SmartSentinel {
    static func monitorLog<T>(impl: JSONDecoderImpl, isOptionalLog: Bool = false,
                                  forKey key: CodingKey, value: JSONValue?, type: T.Type) {
            
            guard SmartSentinel.debugMode != .none else { return }
            
            // 如果被忽略了，就不要输出log了。
            let typeString = String(describing: T.self)
            guard !typeString.starts(with: "IgnoredKey<") else { return }
            
            let className = impl.cache.topSnapshot?.typeName ?? ""
            var path = impl.codingPath
            path.append(key)
            
            var address = ""
            if let parsingMark = CodingUserInfoKey.parsingMark {
                address = impl.userInfo[parsingMark] as? String ?? ""
            }
            
            if let entry = value {
                if entry.isNull { // 值为null
                    if isOptionalLog { return }
                    let error = DecodingError.Keyed._valueNotFound(key: key, expectation: T.self, codingPath: path)
                    SmartSentinel.verboseLog(error, className: className, parsingMark: address)
                } else { // value类型不匹配
                    let error = DecodingError._typeMismatch(at: path, expectation: T.self, desc: entry.debugDataTypeDescription)
                    SmartSentinel.alertLog(error: error, className: className, parsingMark: address)
                }
            } else { // key不存在或value为nil
                if isOptionalLog { return }
                let error = DecodingError.Keyed._keyNotFound(key: key, codingPath: path)
                SmartSentinel.verboseLog(error, className: className, parsingMark: address)
            }
        }
    
    private static func verboseLog(_ error: DecodingError, className: String, parsingMark: String) {
        logIfNeeded(level: .verbose) {
            cache.save(error: error, className: className, parsingMark: parsingMark)
        }
    }
    
    private static func alertLog(error: DecodingError, className: String, parsingMark: String) {
        logIfNeeded(level: .alert) {
            cache.save(error: error, className: className, parsingMark: parsingMark)
        }
    }
    
    static func monitorLogs(in name: String, parsingMark: String) {
        
        guard SmartSentinel.isValid else { return }
        
        if let format = cache.formatLogs(parsingMark: parsingMark) {
            var message: String = ""
            message += getHeader()
            message += name + " 👈🏻 👀\n"
            message += format
            message += getFooter()
            print(message)
        }
        
        cache.clearCache(parsingMark: parsingMark)
    }
}



extension SmartSentinel {
    
    
    
    static func monitorAndPrint(level: SmartSentinel.Level = .alert, debugDescription: String, error: Error? = nil, in type: Any.Type?) {
        logIfNeeded(level: level) {
            let header = getHeader()
            let footer = getFooter()
            
            let decodingError = (error as? DecodingError) ?? DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: debugDescription, underlyingError: error))
            if let logItem = LogItem.make(with: decodingError) {
                if let type = type {
                    let output = "\(type) 👈🏻 👀\n \(logItem.formartMessage)\n"
                    print("\(header)\(output)\(footer)")
                } else {
                    let output = "\(logItem.formartMessage)\n"
                    print("\(header)\(output)\(footer)")
                }
            }
        }
    }
}


extension SmartSentinel {
    /// 生成唯一标记，用来标记是否本次解析。
    static func parsingMark() -> String {
        let mark = "SmartMark" + UUID().uuidString
        return mark
    }
}


extension SmartSentinel {
    
    static func getHeader() -> String {
        return "\n========================  [Smart Decoding Log]  ========================\n"
    }
    
    static func getFooter() -> String {
        return "========================================================================\n"
    }
    
    private static func logIfNeeded(level: SmartSentinel.Level, callback: () -> ()) {
        if SmartSentinel.debugMode.rawValue <= level.rawValue {
            callback()
        }
    }
}
