//
//  KindKit
//

extension Result : DebugTrait where Success : DebugTrait, Failure : DebugTrait {
    
    public func buildInfo() -> Info {
        switch self {
        case .success(let value):
            return ObjectInfo(
                name: "Success",
                info: value
            )
        case .failure(let error):
            return ObjectInfo(
                name: "Failure",
                info: error
            )
        }
    }
    
}
