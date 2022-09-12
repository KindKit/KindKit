//
//  KindKitDatabase
//

import Foundation
import KindKitCore

public protocol IDatabaseValue : IDatabaseExpressable {
    
    associatedtype TypeDeclaration : IDatabaseTypeDeclaration
    
}

// MARK: Bool

extension Bool : IDatabaseValue {
    
    public typealias TypeDeclaration = Database.TypeDeclaration.Integer
    
}

// MARK: Integer

extension IDatabaseValue where Self : BinaryInteger {
    
    public typealias TypeDeclaration = Database.TypeDeclaration.Integer
    
}

extension Int : IDatabaseValue {}
extension Int8 : IDatabaseValue {}
extension Int16 : IDatabaseValue {}
extension Int32 : IDatabaseValue {}
extension Int64 : IDatabaseValue {}
extension UInt : IDatabaseValue {}
extension UInt8 : IDatabaseValue {}
extension UInt16 : IDatabaseValue {}
extension UInt32 : IDatabaseValue {}
extension UInt64 : IDatabaseValue {}

// MARK: Real

extension IDatabaseValue where Self : BinaryFloatingPoint {
    
    public typealias TypeDeclaration = Database.TypeDeclaration.Real
    
}
extension Float : IDatabaseValue {}
extension Double : IDatabaseValue {}

// MARK: Text

extension IDatabaseValue where Self : StringProtocol {
    
    public typealias TypeDeclaration = Database.TypeDeclaration.Text
    
}

extension String : IDatabaseValue {}

// MARK: Blob

extension IDatabaseValue where Self : DataProtocol {

    public typealias TypeDeclaration = Database.TypeDeclaration.Blob

}

extension Data : IDatabaseValue {}

// MARK: Extented

extension Identifier : IDatabaseValue where Raw : IDatabaseValue {
    
    public typealias TypeDeclaration = Raw.TypeDeclaration
    
}

extension Optional : IDatabaseValue where Wrapped : IDatabaseValue {
    
    public typealias TypeDeclaration = Database.TypeDeclaration.Optional< Wrapped.TypeDeclaration >
    
}

extension IDatabaseValue where Self : RawRepresentable, RawValue : IDatabaseValue {
    
    public typealias TypeDeclaration = RawValue.TypeDeclaration
    
}

extension IDatabaseValue where Self : IEnumCodable, RealValue : IDatabaseValue {
    
    public typealias TypeDeclaration = RealValue.TypeDeclaration
    
}
