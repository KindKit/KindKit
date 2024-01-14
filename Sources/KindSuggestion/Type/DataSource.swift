//
//  KindKit
//

import KindDataSource
import KindEvent
import KindNetwork

public final class DataSource< OutputType : Equatable, RequestType, ResponseType : IResponse > : IEntity, IStorable {
    
    public private(set) var store: [OutputType] {
        set {
            guard self._store != newValue else { return }
            self._store = newValue
            self.onStore.emit(self._store)
            self.variants = self._store.map(self._format)
        }
        get {
            return self._store
        }
    }
    public private(set) var variants: [String] {
        set {
            guard self._variants != newValue else { return }
            self._variants = newValue
            self.onVariants.emit(self.variants)
        }
        get {
            return self._variants
        }
    }
    public let onStore = Signal< Void, [OutputType] >()
    public let onVariants = Signal< Void, [String] >()
    
    private var _store: [OutputType] = []
    private var _variants: [String] = []
    private let _prepare: (String) -> RequestType?
    private let _map: (ResponseType.Success) -> [OutputType]
    private let _format: (OutputType) -> String
    private let _dataSource: KindDataSource.Action.Api< RequestType, ResponseType >
    
    public init(
        prepare: @escaping (String) -> RequestType?,
        map: @escaping (ResponseType.Success) -> [OutputType],
        format: @escaping (OutputType) -> String,
        dataSource: KindDataSource.Action.Api< RequestType, ResponseType >
    ) {
        self._prepare = prepare
        self._map = map
        self._format = format
        self._dataSource = dataSource
        
        self._dataSource.onFinish(self, {
            switch $1 {
            case .success(let value):
                $0.store = $0._map(value)
            case .failure:
                $0.store = []
            }
        })
    }
    
    public func begin() {
    }
    
    public func end() {
        self._dataSource.cancel()
        self._store = []
        self._variants = []
    }
    
    public func autoComplete(_ text: String) -> String? {
        return nil
    }
    
    public func variants(_ text: String) {
        guard let input = self._prepare(text) else { return }
        self._dataSource.perform(params: input)
    }
    
}
