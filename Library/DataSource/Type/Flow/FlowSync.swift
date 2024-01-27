//
//  KindKit
//

import KindFlow

public final class FlowSync< Input : ResultTrait, DataSource : Sync > : Operator {
    
    public typealias Input = Input
    public typealias Output = DataSource.Result
    
    private let _dataSource: DataSource
    private var _next: (any Pipe)!
    
    fileprivate init(_ dataSource: DataSource) {
        self._dataSource = dataSource
    }
    
    deinit {
        self._dataSource.cancel()
        self._dataSource.onFinish(disconnect: self)
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success:
                self._dataSource.onFinish(target: self, regular: { target, result in
                    target._dataSource.onFinish(disconnect: target)
                    switch result {
                    case .success(let value): self._next.send(value: value)
                    case .failure(let error): self._next.send(error: error)
                    }
                    self._next.completed()
                })
                self._dataSource.sync()
            case .failure(let error):
                self._dataSource.cancel()
                self._dataSource.onFinish(disconnect: self)
                self._next.send(error: error)
                self._next.completed()
            }
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._dataSource.cancel()
                self._dataSource.onFinish(disconnect: self)
                self._next.cancel()
            }
        }
    }
    
}

extension FlowSync : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func perform< DataSource : Sync >(
        dataSource: DataSource
    ) -> BuilderChain<
        Head,
        FlowSync< Tail.Output, DataSource >
    > {
        return self.append(.init(dataSource))
    }
    
}
