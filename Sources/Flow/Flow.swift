//
//  KindKitFlow
//

import Foundation

public struct Flow< Success, Failure > where Failure : Swift.Error {
    
    public typealias Input = Result< Success, Failure >
    
    public init() {
    }
    
}
