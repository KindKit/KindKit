//
//  KindKit
//

import Foundation

public extension StringFormatter {

    struct ByteCount : IStringFormatter {
        
        public typealias InputType = Int64
        
        public let formatter: ByteCountFormatter
        
        public init(
            units: ByteCountFormatter.Units,
            style: ByteCountFormatter.CountStyle
        ) {
            self.formatter = ByteCountFormatter()
            self.formatter.allowedUnits = units
            self.formatter.countStyle = style
        }
        
        public func format(_ input: InputType) -> String {
            return self.formatter.string(fromByteCount: input)
        }
        
    }

}
