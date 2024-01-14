//
//  KindKit
//

extension Result : IEntity {
    
    public func debugInfo() -> Info {
        switch self {
        case .success(let value):
            return .object(name: "Success", cast: value)
        case .failure(let error):
            return .object(name: "Failure", cast: error)
        }
    }
    
}
