//
//  KindKit
//

import Foundation

public struct DateStringRepresentable : Sendable {
    
    public let locale: Locale?
    public let timeZone: TimeZone?
    public let format: String
    
    public init(
        locale: Locale? = nil,
        timeZone: TimeZone? = nil,
        format: String
    ) {
        self.locale = locale
        self.timeZone = timeZone
        self.format = format
    }
    
}

public extension DateStringRepresentable {
    
    @inlinable
    static var iso8601: Self {
        return .init(
            locale: .init(identifier: "en_US_POSIX"),
            timeZone: .init(secondsFromGMT: 0),
            format: "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        )
    }
    
    @inlinable
    static var iso8601WithoutMilliseconds: Self {
        return .init(
            locale: Locale(identifier: "en_US_POSIX"),
            timeZone: .init(secondsFromGMT: 0),
            format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        )
    }
    
}
