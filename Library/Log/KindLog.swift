//
//  KindKit
//

@_exported import KindDebug

public func register(target: Target) {
    Logger.default.register(target: target)
}

public func unregister(target: Target) {
    Logger.default.unregister(target: target)
}

public func find< TargetType: Target >(_ type: TargetType.Type) -> TargetType? {
    return Logger.default.find(type)
}

public func log(_ message: Message) {
    Logger.default.log(message)
}

public func log(debug message: DebugMessage) {
    Logger.default.log(message)
}

public func log(plain message: PlainMessage) {
    Logger.default.log(message)
}
