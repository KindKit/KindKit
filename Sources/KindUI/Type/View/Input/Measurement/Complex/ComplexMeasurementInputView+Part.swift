//
//  KindKit
//

#if os(iOS)

import Foundation

public extension ComplexMeasurementInputView {
    
    struct Part : Equatable {
        
        public let unit: UnitType
        public let items: [Item]
        
        public init(
            unit: UnitType,
            items: [Item]
        ) {
            self.unit = unit
            self.items = items
        }
        
        public init(
            unit: UnitType,
            unitStyle: Foundation.Formatter.UnitStyle,
            range: Range< Double >,
            step: Double = 1.0
        ) {
            let formatter = MeasurementFormatter()
            formatter.unitStyle = unitStyle
            formatter.unitOptions = .providedUnit
            
            self.init(
                unit: unit,
                formatter: formatter,
                range: range,
                step: step
            )
        }
        
        public init(
            unit: UnitType,
            formatter: MeasurementFormatter,
            range: Range< Double >,
            step: Double = 1.0
        ) {
            var items: [Item] = []
            var value: Double = range.lowerBound
            while value < range.upperBound {
                let measurement = Measurement(value: value, unit: unit)
                items.append(.init(
                    title: formatter.string(from: measurement),
                    value: value
                ))
                value += step
            }
            
            self.init(
                unit: unit,
                items: items
            )
        }
        
    }
        
}

#endif
