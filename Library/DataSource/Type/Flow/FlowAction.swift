//
//  KindKit
//

import KindFlow

public final class FlowAction< Input : ResultTrait, DataSource : Action > : Operator where Input.Success == DataSource.Params {

    public typealias Input = Input
    public typealias Output = DataSource.Result
    
    private let _dataSource: DataSource
    private var _next: (any Pipe)!
    
    fileprivate init(_ dataSource: DataSource) {
        self._dataSource = dataSource
    }
    
    deinit {
        self._dataSource.onFinish(disconnect: self)
        self._dataSource.cancel()
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success(let value):
                self._dataSource.onFinish(target: self, regular: { target, result in
                    target._dataSource.onFinish(disconnect: target)
                    switch result {
                    case .success(let value): self._next.send(value: value)
                    case .failure(let error): self._next.send(error: error)
                    }
                    self._next.completed()
                })
                self._dataSource.perform(params: value)
            case .failure(let error):
                self._dataSource.onFinish(disconnect: self)
                self._dataSource.cancel()
                self._next.send(error: error)
                self._next.completed()
            }
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._dataSource.onFinish(disconnect: self)
                self._dataSource.cancel()
                self._next.cancel()
            }
        }
    }
    
}

extension FlowAction : @unchecked Sendable {
}

public extension BuilderTrait {
    
    func perform< DataSource : Action >(
        dataSource: DataSource
    ) -> BuilderChain<
        Head,
        FlowAction< Tail.Output, DataSource >
    > where
        Tail.Output.Success == DataSource.Params
    {
        return self.append(.init(dataSource))
    }
    
}
