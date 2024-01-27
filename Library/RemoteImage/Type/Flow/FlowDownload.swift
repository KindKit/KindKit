//
//  KindKit
//

import KindFlow
import KindGraphics
import KindLog
import KindMeasure

public final class FlowDownload< Input : ResultTrait > : Operator {
    
    public typealias Input = Input
    public typealias Output = Result< Image, Error >
    
    public typealias QueryClosure = @Sendable (Input.Success) -> Query
    public typealias FilterClosure = @Sendable (Input.Success) -> Filter
    
    private let _loader: Loader
    private let _query: QueryClosure
    private let _filter: FilterClosure?
    private var _next: KindFlow.Pipe!
    
    init(
        _ loader: Loader,
        _ query: @escaping QueryClosure,
        _ filter: FilterClosure?
    ) {
        self._loader = loader
        self._query = query
        self._filter = filter
    }
    
    deinit {
        self._loader.cancel(target: self)
    }
    
    public func connect(next: any Pipe) {
        self._next = next
    }
    
    public func receive(_ state: InputState) {
        switch state {
        case .result(let result):
            switch result {
            case .success(let value):
                self._loader.download(
                    target: self,
                    query: self._query(value),
                    filter: self._filter?(value)
                )
            case .failure(let error):
                self._loader.cancel(target: self)
                self._next.send(error: error)
                self._next.completed()
            }
        case .control(let control):
            switch control {
            case .completed:
                break
            case .canceled:
                self._loader.cancel(target: self)
                self._next.cancel()
            }
        }
    }
    
}

extension FlowDownload : @unchecked Sendable {
}

extension FlowDownload : Target {
    
    public func remoteImage(progress: Percent) {
    }
    
    public func remoteImage(image: Image) {
        self._next.send(value: image)
        self._next.completed()
    }
    
    public func remoteImage(error: Error) {
        self._next.send(error: error)
        self._next.completed()
    }
    
}

public extension BuilderTrait {
    
    func remoteImage(
        loader: Loader = .shared,
        query: @escaping @Sendable (Tail.Output.Success) -> Query
    ) -> BuilderChain<
        Head,
        FlowDownload< Tail.Output >
    > {
        return self.append(.init(loader, query, nil))
    }
    
    func remoteImage(
        loader: Loader = .shared,
        query: @escaping @Sendable (Tail.Output.Success) -> Query,
        filter: @escaping @Sendable (Tail.Output.Success) -> Filter
    ) -> BuilderChain<
        Head,
        FlowDownload< Tail.Output >
    > {
        return self.append(.init(loader, query, filter))
    }
    
}
