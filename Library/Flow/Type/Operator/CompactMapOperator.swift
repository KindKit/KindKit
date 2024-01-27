//
//  KindKit
//

public extension BuilderTrait {
    
    func compactMap< Success, Failure : Swift.Error >(
        _ map: @escaping @Sendable (Result< Tail.Output.Success, Tail.Output.Failure >) -> Result< Success, Failure >?
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init(map))
    }
    
    func compactMap< Success >(
        value map: @escaping @Sendable (Tail.Output.Success) -> Success?
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Tail.Output.Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value):
                if let value = map(value) {
                    return .success(value)
                }
                return nil
            case .failure(let error):
                return .failure(error)
            }
        }))
    }
    
    func compactMap< Failure : Swift.Error >(
        error map: @escaping @Sendable (Tail.Output.Failure) -> Failure?
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result<Tail.Output.Success, Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value):
                return .success(value)
            case .failure(let error):
                if let error = map(error) {
                    return .failure(error)
                }
                return nil
            }
        }))
    }
    
}

public extension BuilderTrait where Tail.Output.Failure == Never {
    
    func compactMap< Success, Failure : Swift.Error >(
        value map: @escaping @Sendable (Tail.Output.Success) -> Result< Success, Failure >?
    ) -> BuilderChain<
        Head,
        MapOperator< Tail.Output, Result< Success, Failure > >
    > {
        return self.append(.init({ input in
            switch input {
            case .success(let value): return map(value)
            case .failure: return nil
            }
        }))
    }
    
}

