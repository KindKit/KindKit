//
//  KindKit
//

import KindCore

public extension BuilderTrait {
    
    func filter(
        _ map: @escaping @Sendable (Tail.OutputResult) -> Bool
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Tail.Output >
    > {
        return self.append(.init({ input in
            if map(input) == true {
                return input
            }
            return nil
        }))
    }
    
    func filter(
        value map: @escaping @Sendable (Tail.Output.Success) -> Bool
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Tail.OutputResult >
    > {
        return self.append(.init({ input in
            guard case .success(let value) = input else {
                return input
            }
            if map(value) == true {
                return .success(value)
            }
            return nil
        }))
    }
    
    func filter(
        error map: @escaping @Sendable (Tail.Output.Failure) -> Bool
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Tail.OutputResult >
    > {
        return self.append(.init({ input in
            guard case .failure(let error) = input else {
                return input
            }
            if map(error) == true {
                return .failure(error)
            }
            return nil
        }))
    }
    
}
