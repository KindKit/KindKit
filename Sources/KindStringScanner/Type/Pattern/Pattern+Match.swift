//
//  KindKit
//

extension Pattern {
    
    public struct Match : Equatable {
        
        public let full: Pattern.Match.Part?
        public let parts: [Pattern.Match.Part]
        
        public init() {
            self.full = nil
            self.parts = []
        }
        
        public init(
            full: Pattern.Match.Part?,
            parts: [Pattern.Match.Part]
        ) {
            self.full = full
            self.parts = parts
        }
        
        public func append(_ scan: Scanner.Result) -> Self {
            return self.append(.init(scan))
        }
        
        public func append(_ part: Pattern.Match.Part) -> Self {
            if let full = self.full {
                return .init(
                    full: .init(
                        range: .init(uncheckedBounds: (
                            lower: min(full.range.lowerBound, part.range.lowerBound),
                            upper: max(full.range.upperBound, part.range.upperBound)
                        )),
                        string: full.string + part.string
                    ),
                    parts: self.parts.kk_appending(part)
                )
            }
            return .init(
                full: part,
                parts: [ part ]
            )
        }
        
    }
    
}
