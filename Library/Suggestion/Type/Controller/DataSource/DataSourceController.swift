//
//  KindKit
//

import KindDataSource
import KindEvent
import KindNetwork

public final class DataSourceController< Item : KindSuggestion.Item, Request : Sendable, Response : KindNetwork.Response > : Controller {
    
    public typealias DataSource = KindDataSource.ApiAction< Request, Response >
    
    public let dataSource: DataSource
    
    public private(set) var isStarting: Bool = false
    
    public private(set) var items: [Item] = [] {
        didSet {
            guard self.items != oldValue else { return }
            if self.isStarting == true {
                self.onItems.emit(self.items)
            }
        }
    }
    public let onItems = Signal< Void, [Item] >()
    
    private let _prepare: (String) -> Request?
    private let _map: (Response.Success) -> [Item]
    
    public init(
        prepare: @escaping (String) -> Request?,
        map: @escaping (Response.Success) -> [Item],
        dataSource: DataSource
    ) {
        self._prepare = prepare
        self._map = map
        self.dataSource = dataSource
        
        do {
            self.dataSource.onFinish(target: self, regular: {
                switch $1 {
                case .success(let value): $0.items = $0._map(value)
                case .failure: $0.items = []
                }
            })
        }
    }
    
    deinit {
        self.dataSource.onFinish(disconnect: self)
    }
    
    public func start() {
        guard self.isStarting == false else { return }
        self.isStarting = true
    }
    
    public func update(_ input: String) {
        guard self.isStarting == true else { return }
        guard let input = self._prepare(input) else { return }
        self.dataSource.perform(params: input)
    }
    
    public func stop() {
        guard self.isStarting == true else { return }
        self.isStarting = false
        self.dataSource.cancel()
        self.items = []
    }
    
}

extension DataSourceController : @unchecked Sendable {
}
