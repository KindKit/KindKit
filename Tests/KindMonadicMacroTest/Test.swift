//
//  TestMacro
//

#if os(macOS)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import KindMonadicMacroPlugin

final class Test : XCTestCase {
    
    func testStruct() {
        assertMacroExpansion(
            #"""
            @KindMonadic
            struct S1 {
                @KindMonadicProperty
                public let p1: String
                @KindMonadicProperty
                public var p2: String
                public var p3: String {
                    set {
                        let part = newValue.components(separatedBy: " ")
                        self.p1 = part[0]
                        self.p2 = part[1]
                    }
                    get {
                        return self.p1 + self.p2
                    }
                }
                public var p4: String {
                    return self.p1 + self.p2
                }
            }
            """#,
            expandedSource: #"""
            struct S1 {
                public let p1: String
                public var p2: String
                public var p3: String {
                    set {
                        let part = newValue.components(separatedBy: " ")
                        self.p1 = part[0]
                        self.p2 = part[1]
                    }
                    get {
                        return self.p1 + self.p2
                    }
                }
                public var p4: String {
                    return self.p1 + self.p2
                }
            
                @inlinable public func p1(_ value: String) -> Self {
                    return .init(p1: value, p2: self.p2)
                }
            
                @inlinable public func p2(_ value: String) -> Self {
                    return .init(p1: self.p1, p2: value)
                }
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self
            ]
        )
    }
    
    func testStructCondition() {
        assertMacroExpansion(
            #"""
            @KindMonadic
            struct S1 {
                @KindMonadicProperty
                public let p1: String
            #if os(macOS)
                @KindMonadicProperty
                public let p2: String
            #elseif os(iOS)
                @KindMonadicProperty
                public let p3: String
            #endif
            
                public init(p1: String, p2: String, p3: String) {
                    self.p1 = p1
                    #if os(macOS)
                    self.p2 = p2
                    #endif
                    #if os(isOS)
                    self.p3 = p3
                    #endif
                }
            }
            """#,
            expandedSource: #"""
            struct S1 {
                public let p1: String
            #if os(macOS)
                public let p2: String
            #elseif os(iOS)
                public let p3: String
            #endif
            
                public init(p1: String, p2: String, p3: String) {
                    self.p1 = p1
                    #if os(macOS)
                    self.p2 = p2
                    #endif
                    #if os(isOS)
                    self.p3 = p3
                    #endif
                }
            
                @inlinable public func p1(_ value: String) -> Self {
                    return .init(p1: value, p2: self.p2, p3: self.p3)
                }
            
                #if os(macOS)
                @inlinable public func p2(_ value: String) -> Self {
                    return .init(p1: self.p1, p2: value, p3: self.p3)
                }
                #endif
            
                #if os(iOS)
                @inlinable public func p3(_ value: String) -> Self {
                    return .init(p1: self.p1, p2: self.p2, p3: value)
                }
                #endif
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self
            ]
        )
    }
    
    func testClass() {
        assertMacroExpansion(
            #"""
            @KindMonadic
            class C1 {
                @KindMonadicProperty
                var p1: Bool
                @KindMonadicProperty
                @KindMonadicProperty(alias: "a1")
                let p2: Int
                @KindMonadicProperty
                @KindMonadicProperty(alias: "a2")
                var p3: Int
                @KindMonadicSignal
                let onS1: Signal< Void, Void >
            #if os(macOS)
                @KindMonadicSignal
                let onS2 = Signal< Void, Void >()
            #elseif os(iOS)
                @KindMonadicSignal
                let onS3 = Signal< Void, Void >()
            #endif
            }
            @KindMonadic
            class C2< T : Comparable > {
                @KindMonadicProperty
                var p1: T {
                    set { self._p1 = newValue }
                    get { self._p1 }
                }
                private var _p1: T
                @KindMonadicProperty
                var p2: T {
                    didSet { self._p1 = self.p2 }
                }
            }
            """#,
            expandedSource: #"""
            class C1 {
                var p1: Bool
                let p2: Int
                var p3: Int
                let onS1: Signal< Void, Void >
            #if os(macOS)
                let onS2 = Signal< Void, Void >()
            #elseif os(iOS)
                let onS3 = Signal< Void, Void >()
            #endif
            
                var a1: Int {
                    get {
                        self.p2
                    }
                }
            
                var a2: Int {
                    set {
                        self.p3 = newValue
                    }
                    get {
                        self.p3
                    }
                }
            
                @inlinable @discardableResult func p1(_ value: Bool) -> Self {
                    self.p1 = value
                    return self
                }
            
                @inlinable @discardableResult func p1(_ value: () -> Bool) -> Self {
                    self.p1 = value()
                    return self
                }
            
                @inlinable @discardableResult func p1(_ value: (Self) -> Bool) -> Self {
                    self.p1 = value(self)
                    return self
                }
            
                @inlinable @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
            
                @inlinable @discardableResult func p3(_ value: () -> Int) -> Self {
                    self.p3 = value()
                    return self
                }
            
                @inlinable @discardableResult func p3(_ value: (Self) -> Int) -> Self {
                    self.p3 = value(self)
                    return self
                }
            
                @inlinable @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
            
                @inlinable @discardableResult func a2(_ value: () -> Int) -> Self {
                    self.a2 = value()
                    return self
                }
            
                @inlinable @discardableResult func a2(_ value: (Self) -> Int) -> Self {
                    self.a2 = value(self)
                    return self
                }
            
                @inlinable @discardableResult func onS1(_ closure: @escaping() -> Void) -> Self {
                    self.onS1.add(closure)
                    return self
                }
            
                @inlinable @discardableResult func onS1(_ closure: @escaping(Self) -> Void) -> Self {
                    self.onS1.add(self, closure)
                    return self
                }
            
                @inlinable @discardableResult func onS1<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
                    self.onS1.add(target, closure)
                    return self
                }
            
                @inlinable @discardableResult func onS1(remove target: AnyObject) -> Self {
                    self.onS1.remove(target)
                    return self
                }
            
                #if os(macOS)
                @inlinable @discardableResult func onS2(_ closure: @escaping() -> Void) -> Self {
                    self.onS2.add(closure)
                    return self
                }
                @inlinable @discardableResult func onS2(_ closure: @escaping(Self) -> Void) -> Self {
                    self.onS2.add(self, closure)
                    return self
                }
                @inlinable @discardableResult func onS2<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
                    self.onS2.add(target, closure)
                    return self
                }
                @inlinable @discardableResult func onS2(remove target: AnyObject) -> Self {
                    self.onS2.remove(target)
                    return self
                }
                #endif
            
                #if os(iOS)
                @inlinable @discardableResult func onS3(_ closure: @escaping() -> Void) -> Self {
                    self.onS3.add(closure)
                    return self
                }
                @inlinable @discardableResult func onS3(_ closure: @escaping(Self) -> Void) -> Self {
                    self.onS3.add(self, closure)
                    return self
                }
                @inlinable @discardableResult func onS3<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
                    self.onS3.add(target, closure)
                    return self
                }
                @inlinable @discardableResult func onS3(remove target: AnyObject) -> Self {
                    self.onS3.remove(target)
                    return self
                }
                #endif
            }
            class C2< T : Comparable > {
                var p1: T {
                    set { self._p1 = newValue }
                    get { self._p1 }
                }
                private var _p1: T
                var p2: T {
                    didSet { self._p1 = self.p2 }
                }
            
                @inlinable @discardableResult func p1(_ value: T) -> Self {
                    self.p1 = value
                    return self
                }
            
                @inlinable @discardableResult func p1(_ value: () -> T) -> Self {
                    self.p1 = value()
                    return self
                }
            
                @inlinable @discardableResult func p1(_ value: (Self) -> T) -> Self {
                    self.p1 = value(self)
                    return self
                }
            
                @inlinable @discardableResult func p2(_ value: T) -> Self {
                    self.p2 = value
                    return self
                }
            
                @inlinable @discardableResult func p2(_ value: () -> T) -> Self {
                    self.p2 = value()
                    return self
                }
            
                @inlinable @discardableResult func p2(_ value: (Self) -> T) -> Self {
                    self.p2 = value(self)
                    return self
                }
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self,
                "KindMonadicSignal": DummyMacro.self
            ]
        )
    }
    
    func testProtocol() {
        assertMacroExpansion(
            #"""
            @KindMonadic
            protocol P1 {
                @KindMonadicProperty
                var p1: Bool { set get }
                @KindMonadicProperty
                @KindMonadicProperty(alias: "a1")
                var p2: Int { get }
                @KindMonadicProperty
                @KindMonadicProperty(alias: "a2")
                var p3: Int { set get }
                @KindMonadicSignal
                var onS1: Signal.Empty< Void > { set get }
                @KindMonadicSignal
                var onS2: Signal.Empty< Void > { set get }
            }
            """#,
            expandedSource: #"""
            protocol P1 {
                var p1: Bool { set get }
                var p2: Int { get }
                var p3: Int { set get }
                var onS1: Signal.Empty< Void > { set get }
                var onS2: Signal.Empty< Void > { set get }
            }
            
            extension P1 {
                var a1: Int {
                    get {
                        self.p2
                    }
                }
                var a2: Int {
                    set {
                        self.p3 = newValue
                    }
                    get {
                        self.p3
                    }
                }
                @inlinable @discardableResult func p1(_ value: Bool) -> Self {
                    self.p1 = value
                    return self
                }
                @inlinable @discardableResult func p1(_ value: () -> Bool) -> Self {
                    self.p1 = value()
                    return self
                }
                @inlinable @discardableResult func p1(_ value: (Self) -> Bool) -> Self {
                    self.p1 = value(self)
                    return self
                }
                @inlinable @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
                @inlinable @discardableResult func p3(_ value: () -> Int) -> Self {
                    self.p3 = value()
                    return self
                }
                @inlinable @discardableResult func p3(_ value: (Self) -> Int) -> Self {
                    self.p3 = value(self)
                    return self
                }
                @inlinable @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
                @inlinable @discardableResult func a2(_ value: () -> Int) -> Self {
                    self.a2 = value()
                    return self
                }
                @inlinable @discardableResult func a2(_ value: (Self) -> Int) -> Self {
                    self.a2 = value(self)
                    return self
                }
                @inlinable @discardableResult func onS1(_ closure: @escaping() -> Void) -> Self {
                    self.onS1.add(closure)
                    return self
                }
                @inlinable @discardableResult func onS1(_ closure: @escaping(Self) -> Void) -> Self {
                    self.onS1.add(self, closure)
                    return self
                }
                @inlinable @discardableResult func onS1<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
                    self.onS1.add(target, closure)
                    return self
                }
                @inlinable @discardableResult func onS1(remove target: AnyObject) -> Self {
                    self.onS1.remove(target)
                    return self
                }
                @inlinable @discardableResult func onS2(_ closure: @escaping() -> Void) -> Self {
                    self.onS2.add(closure)
                    return self
                }
                @inlinable @discardableResult func onS2(_ closure: @escaping(Self) -> Void) -> Self {
                    self.onS2.add(self, closure)
                    return self
                }
                @inlinable @discardableResult func onS2<TargetType>(_ target: TargetType, _ closure: @escaping(TargetType) -> Void) -> Self where TargetType: AnyObject {
                    self.onS2.add(target, closure)
                    return self
                }
                @inlinable @discardableResult func onS2(remove target: AnyObject) -> Self {
                    self.onS2.remove(target)
                    return self
                }
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self,
                "KindMonadicSignal": DummyMacro.self
            ]
        )
    }
    
    func testStructGeneric() {
        assertMacroExpansion(
            #"""
            @KindMonadic
            struct S1< G1 > {
                @KindMonadicProperty(default: Default.self)
                @KindMonadicProperty(builder: Builder.self)
                public let p1: G1
            
                public init(_ p1: G1) {
                    self.p1 = p1
                }
            }
            """#,
            expandedSource: #"""
            struct S1< G1 > {
                public let p1: G1
            
                public init(_ p1: G1) {
                    self.p1 = p1
                }
            
                @inlinable public init(@Builder _ p1: () -> G1) {
                    self.init(p1())
                }
            
                @inlinable public init() where G1 == Default {
                    self.init(Default())
                }
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self
            ]
        )
        assertMacroExpansion(
            #"""
            @KindMonadic
            struct S1< G1, G2 > {
                @KindMonadicProperty(default: Default.self)
                @KindMonadicProperty(builder: Builder.self)
                public let p1: G1
                @KindMonadicProperty(default: Default.self)
                @KindMonadicProperty(builder: Builder.self)
                public let p2: G2
            
                public init(p1: G1, p2: G2) {
                    self.p1 = p1
                    self.p2 = p2
                }
            }
            """#,
            expandedSource: #"""
            struct S1< G1, G2 > {
                public let p1: G1
                public let p2: G2
            
                public init(p1: G1, p2: G2) {
                    self.p1 = p1
                    self.p2 = p2
                }
            
                @inlinable public init(@Builder p1: () -> G1, p2: G2) {
                    self.init(p1: p1(), p2: p2)
                }
            
                @inlinable public init(p2: G2) where G1 == Default {
                    self.init(p1: Default(), p2: p2)
                }
            
                @inlinable public init(p1: G1, @Builder p2: () -> G2) {
                    self.init(p1: p1, p2: p2())
                }
            
                @inlinable public init(@Builder p1: () -> G1, @Builder p2: () -> G2) {
                    self.init(p1: p1(), p2: p2())
                }
            
                @inlinable public init(@Builder p2: () -> G2) where G1 == Default {
                    self.init(p1: Default(), p2: p2())
                }
            
                @inlinable public init(p1: G1) where G2 == Default {
                    self.init(p1: p1, p2: Default())
                }
            
                @inlinable public init(@Builder p1: () -> G1) where G2 == Default {
                    self.init(p1: p1(), p2: Default())
                }
            
                @inlinable public init() where G1 == Default, G2 == Default {
                    self.init(p1: Default(), p2: Default())
                }
            }
            """#,
            macros: [
                "KindMonadic": ExpansionMacro.self,
                "KindMonadicProperty": DummyMacro.self
            ]
        )
    }
     
}

#endif
