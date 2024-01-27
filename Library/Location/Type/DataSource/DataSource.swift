//
//  KindKit
//

import CoreLocation
import KindDataSource
import KindEvent
import KindPermission

public final class DataSource : KindDataSource.Sync {
    
    public typealias Success = CLLocation
    public typealias Failure = Error
    public typealias Result = Swift.Result< Success, Failure >
    
    public let permission: Permission
    public let behaviour: SyncBehaviour
    public private(set) var result: Result?
    public let onFinish = Signal< Void, Result >()
    public private(set) var isSyncing: Bool
    public var isNeedSync: Bool {
        return self.behaviour.isNeedSync(self.syncAt)
    }
    public private(set) var syncAt: Date?
    
    private var _task: CancelTrait? {
        willSet { self._task?.cancel() }
    }
    private var _manager: CLLocationManager? {
        willSet {
            guard let manager = self._manager, self._manager !== newValue else { return }
            manager.delegate = nil
        }
        didSet {
            guard let manager = self._manager, self._manager !== oldValue else { return }
            manager.delegate = self._managerDelegate
            manager.requestLocation()
        }
    }
    private var _managerDelegate: Delegate!
    
    public init(
        permission: Permission,
        behaviour: SyncBehaviour
    ) {
        self.permission = permission
        self.behaviour = behaviour
        self.isSyncing = false
        self._managerDelegate = .init(self)
        self._setup()
    }
    
    deinit {
        self._destroy()
        self.cancel()
    }
    
    public func setNeedSync(reset: Bool) {
        if reset == true {
            self.result = nil
        }
        self.syncAt = nil
    }
    
    public func sync() {
        guard self.isSyncing == false else { return }
        self.isSyncing = true
        Task(operation: {
            switch self.permission.status {
            case .notSupported:
                self._completed(.failure(.serviceUnavailable))
            case .denied:
                self._completed(.failure(.permissionDenied))
            case .notDetermined:
                _ = await self.permission.request()
            case .authorized:
                self._manager = CLLocationManager()
            case .none:
                break
            }
        })
    }
    
    public func cancel() {
        self._task = nil
        self._manager = nil
        self.isSyncing = false
    }
    
}

extension DataSource : @unchecked Sendable {
}

extension DataSource {
    
    final class Delegate : NSObject, CLLocationManagerDelegate {
        
        unowned(unsafe) var dataSource: DataSource
        
        init(
            _ dataSource: DataSource
        ) {
            self.dataSource = dataSource
            super.init()
        }
        
        func locationManager(
            _ manager: CLLocationManager,
            didUpdateLocations locations: [CLLocation]
        ) {
            if let location = locations.first {
                self.dataSource._completed(.success(location))
            }
        }
        
        func locationManager(
            _ manager: CLLocationManager,
            didFailWithError error: Swift.Error
        ) {
            self.dataSource._completed(.failure(.error(error)))
        }
        
    }
    
}

private extension DataSource {
    
    func _setup() {
        self.permission.onDidRequest(target: self, regular: { target in
            Task(operation: {
                switch target.permission.status {
                case .notSupported: target._completed(.failure(.serviceUnavailable))
                case .notDetermined, .denied: target._completed(.failure(.permissionDenied))
                case .authorized: target._manager = CLLocationManager()
                case .none: break
                }
            })
        })
    }
    
    func _destroy() {
        self.permission.onDidRequest(disconnect: self)
    }

    func _completed(_ result: Result) {
        self.isSyncing = false
        self._manager = nil
        self._task = nil
        switch result {
        case .success:
            self.result = result
            self.syncAt = Date()
        case .failure:
            self.result = result
        }
        self.onFinish.emit(result)
    }
    
}
