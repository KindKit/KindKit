//
//  KindKit
//

#if canImport(CoreLocation)

import CoreLocation

public extension DataSource.Sync {
    
    final class Location : ISyncDataSource {
        
        public typealias Success = CLLocation
        public typealias Failure = Error
        public typealias Result = Swift.Result< Success, Failure >
        
        public let permission: Permission.Location
        public let behaviour: Behaviour
        public private(set) var result: Result?
        public let onFinish: Signal.Args< Void, Result > = .init()
        public private(set) var isSyncing: Bool
        public var isNeedSync: Bool {
            return self.behaviour.isNeedSync(self.syncAt)
        }
        public private(set) var syncAt: Date?
        
        private var _task: ICancellable? {
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
            permission: Permission.Location,
            behaviour: Behaviour
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
            switch self.permission.status {
            case .notSupported:
                self._task = DispatchWorkItem.kk_async(block: { [weak self] in
                    guard let self = self else { return }
                    self._completed(.failure(.serviceUnavailable))
                })
            case .denied:
                self._task = DispatchWorkItem.kk_async(block: { [weak self] in
                    guard let self = self else { return }
                    self._completed(.failure(.permissionDenied))
                })
            case .notDetermined:
                self.permission.request(source: self)
            case .authorized:
                self._manager = CLLocationManager()
            }
        }
        
        public func cancel() {
            self._task = nil
            self._manager = nil
            self.isSyncing = false
        }

    }
    
}

extension DataSource.Sync.Location : IPermissionObserver {
    
    public func didRequest(
        _ permission: IPermission,
        source: Any?
    ) {
        switch permission.status {
        case .notSupported:
            self._completed(.failure(.serviceUnavailable))
        case .notDetermined, .denied:
            self._completed(.failure(.permissionDenied))
        case .authorized:
            self._manager = CLLocationManager()
        }
    }
    
}

extension DataSource.Sync.Location {
    
    final class Delegate : NSObject, CLLocationManagerDelegate {
        
        unowned var dataSource: DataSource.Sync.Location
        
        init(
            _ dataSource: DataSource.Sync.Location
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

private extension DataSource.Sync.Location {
    
    func _setup() {
        self.permission.add(observer: self, priority: .internal)
    }
    
    func _destroy() {
        self.permission.remove(observer: self)
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

public extension ISyncDataSource where Self : DataSource.Sync.Location {
    
    static func location(
        permission: Permission.Location,
        behaviour: DataSource.Sync.Behaviour
    ) -> Self {
        return .init(
            permission: permission,
            behaviour: behaviour
        )
    }
    
}

#endif
