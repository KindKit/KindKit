//
//  KindKit
//

import Foundation

extension Applier.View {
    
    public struct DateText<
        FormatterType : IFormatter
    > : IApplier where
        FormatterType.InputType == Date,
        FormatterType.OutputType == String
    {
        
        public let formatter: FormatterType
        
        public init(
            formatter: FormatterType
        ) {
            self.formatter = formatter
        }
        
        public func apply(_ input: Date, _ target: UI.View.Text) {
            target.text = self.formatter.format(input)
        }
        
    }
    
}
