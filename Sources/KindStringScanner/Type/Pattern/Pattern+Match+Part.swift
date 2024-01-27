//
//  KindKit
//

extension Pattern.Match {
    
    public struct Part : Equatable {
        
        public let range: Scanner.Range
        public let string: String
        
        public init(
            range: Scanner.Range,
            string: String
        ) {
            self.range = range
            self.string = string
        }
        
        public init(_ result: Scanner.Result) {
            self.init(
                range: result.range, 
                string: .init(result.content)
            )
        }
        
    }
    
}
