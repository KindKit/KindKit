//
//  KindKit
//

import KindFlow

public final class FlowPage< Input : ResultTrait, DataSource : Page > : Operator {
    
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
                self._dataSource.load()
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

extension FlowPage : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func perform< DataSource : Page >(
        dataSource: DataSource
    ) -> BuilderChain<
        Head,
        FlowPage< Tail.Output, DataSource >
    > {
        return self.append(.init(dataSource))
    }
    
}
