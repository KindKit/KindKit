//
//  TestMacro
//

#if os(macOS)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import KindMonadicMacro
@testable import KindMonadicMacroPlugin

final class Test : XCTestCase {
    
    func testStruct() {
        assertMacroExpansion(
            #"""
            @Monadic
            struct S1 {
                @MonadicField
                public let p1: String
                @MonadicField
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
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self
            ]
        )
    }
    
    func testStructCondition() {
        assertMacroExpansion(
            #"""
            @Monadic
            struct S1 {
                @MonadicField
                public let p1: String
            #if os(macOS)
                @MonadicField
                public let p2: String
            #elseif os(iOS)
                @MonadicField
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
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self
            ]
        )
    }
    
    func testClass() {
        assertMacroExpansion(
            #"""
            @Monadic
            class C1 {
                @MonadicField
                var p1: Bool
                @MonadicField
                @MonadicField(alias: "a1")
                let p2: Int
                @MonadicField
                @MonadicField(alias: "a2")
                var p3: Int
                @MonadicSignal
                let onS1: Signal< Void, Void >
            #if os(macOS)
                @MonadicSignal
                let onS2 = Signal< Void, Void >()
            #elseif os(iOS)
                @MonadicSignal
                let onS3 = Signal< Void, Void >()
            #endif
            }
            @Monadic
            class C2< T : Comparable > {
                @MonadicField
                var p1: T {
                    set { self._p1 = newValue }
                    get { self._p1 }
                }
                private var _p1: T
                @MonadicField
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
            
                @discardableResult func p1(_ value: Bool) -> Self {
                    self.p1 = value
                    return self
                }
            
                @discardableResult func p1(on: () -> Bool) -> Self {
                    self.p1 = on()
                    return self
                }
            
                @discardableResult func p1(on: (Self) -> Bool) -> Self {
                    self.p1 = on(self)
                    return self
                }
            
                @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
            
                @discardableResult func p3(on: () -> Int) -> Self {
                    self.p3 = on()
                    return self
                }
            
                @discardableResult func p3(on: (Self) -> Int) -> Self {
                    self.p3 = on(self)
                    return self
                }
            
                @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
            
                @discardableResult func a2(on: () -> Int) -> Self {
                    self.a2 = on()
                    return self
                }
            
                @discardableResult func a2(on: (Self) -> Int) -> Self {
                    self.a2 = on(self)
                    return self
                }
            
                @discardableResult func onS1(regular closure: @escaping () -> Void) -> Self {
                    self.onS1.connect(regular: closure)
                    return self
                }
            
                @discardableResult func onS1(regular closure: @escaping (Self) -> Void) -> Self {
                    self.onS1.connect(capture: .weak(self), regular: closure)
                    return self
                }
            
                @discardableResult func onS1<Target>(target: Target, regular closure: @escaping (Target) -> Void) -> Self where Target: AnyObject {
                    self.onS1.connect(capture: .weak(target), regular: closure)
                    return self
                }
            
                @discardableResult func onS1(disconnect target: AnyObject) -> Self {
                    self.onS1.disconnect(target)
                    return self
                }
            
                #if os(macOS)
                @discardableResult func onS2(regular closure: @escaping () -> Void) -> Self {
                    self.onS2.connect(regular: closure)
                    return self
                }
                @discardableResult func onS2(regular closure: @escaping (Self) -> Void) -> Self {
                    self.onS2.connect(capture: .weak(self), regular: closure)
                    return self
                }
                @discardableResult func onS2<Target>(target: Target, regular closure: @escaping (Target) -> Void) -> Self where Target: AnyObject {
                    self.onS2.connect(capture: .weak(target), regular: closure)
                    return self
                }
                @discardableResult func onS2(disconnect target: AnyObject) -> Self {
                    self.onS2.disconnect(target)
                    return self
                }
                #endif
            
                #if os(iOS)
                @discardableResult func onS3(regular closure: @escaping () -> Void) -> Self {
                    self.onS3.connect(regular: closure)
                    return self
                }
                @discardableResult func onS3(regular closure: @escaping (Self) -> Void) -> Self {
                    self.onS3.connect(capture: .weak(self), regular: closure)
                    return self
                }
                @discardableResult func onS3<Target>(target: Target, regular closure: @escaping (Target) -> Void) -> Self where Target: AnyObject {
                    self.onS3.connect(capture: .weak(target), regular: closure)
                    return self
                }
                @discardableResult func onS3(disconnect target: AnyObject) -> Self {
                    self.onS3.disconnect(target)
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
            
                @discardableResult func p1(_ value: T) -> Self {
                    self.p1 = value
                    return self
                }
            
                @discardableResult func p1(on: () -> T) -> Self {
                    self.p1 = on()
                    return self
                }
            
                @discardableResult func p1(on: (Self) -> T) -> Self {
                    self.p1 = on(self)
                    return self
                }
            
                @discardableResult func p2(_ value: T) -> Self {
                    self.p2 = value
                    return self
                }
            
                @discardableResult func p2(on: () -> T) -> Self {
                    self.p2 = on()
                    return self
                }
            
                @discardableResult func p2(on: (Self) -> T) -> Self {
                    self.p2 = on(self)
                    return self
                }
            }
            """#,
            macros: [
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self,
                "MonadicSignal": DummyMacro.self
            ]
        )
    }
    
    func testProtocol() {
        assertMacroExpansion(
            #"""
            @Monadic
            protocol P1 {
                @MonadicField
                var p1: Bool { set get }
                @MonadicField
                @MonadicField(alias: "a1")
                var p2: Int { get }
                @MonadicField
                @MonadicField(alias: "a2")
                var p3: Int { set get }
                @MonadicSignal
                var onS1: Signal.Empty< Void > { set get }
                @MonadicSignal
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
                @discardableResult func p1(_ value: Bool) -> Self {
                    self.p1 = value
                    return self
                }
                @discardableResult func p1(on: () -> Bool) -> Self {
                    self.p1 = on()
                    return self
                }
                @discardableResult func p1(on: (Self) -> Bool) -> Self {
                    self.p1 = on(self)
                    return self
                }
                @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
                @discardableResult func p3(on: () -> Int) -> Self {
                    self.p3 = on()
                    return self
                }
                @discardableResult func p3(on: (Self) -> Int) -> Self {
                    self.p3 = on(self)
                    return self
                }
                @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
                @discardableResult func a2(on: () -> Int) -> Self {
                    self.a2 = on()
                    return self
                }
                @discardableResult func a2(on: (Self) -> Int) -> Self {
                    self.a2 = on(self)
                    return self
                }
                @discardableResult func onS1(regular closure: @escaping () -> Void) -> Self {
                    self.onS1.connect(regular: closure)
                    return self
                }
                @discardableResult func onS1(regular closure: @escaping (Self) -> Void) -> Self {
                    self.onS1.connect(capture: .weak(self), regular: closure)
                    return self
                }
                @discardableResult func onS1<Target>(target: Target, regular closure: @escaping (Target) -> Void) -> Self where Target: AnyObject {
                    self.onS1.connect(capture: .weak(target), regular: closure)
                    return self
                }
                @discardableResult func onS1(disconnect target: AnyObject) -> Self {
                    self.onS1.disconnect(target)
                    return self
                }
                @discardableResult func onS2(regular closure: @escaping () -> Void) -> Self {
                    self.onS2.connect(regular: closure)
                    return self
                }
                @discardableResult func onS2(regular closure: @escaping (Self) -> Void) -> Self {
                    self.onS2.connect(capture: .weak(self), regular: closure)
                    return self
                }
                @discardableResult func onS2<Target>(target: Target, regular closure: @escaping (Target) -> Void) -> Self where Target: AnyObject {
                    self.onS2.connect(capture: .weak(target), regular: closure)
                    return self
                }
                @discardableResult func onS2(disconnect target: AnyObject) -> Self {
                    self.onS2.disconnect(target)
                    return self
                }
            }
            """#,
            macros: [
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self,
                "MonadicSignal": DummyMacro.self
            ]
        )
    }
    
    func testStructGeneric() {
        assertMacroExpansion(
            #"""
            @Monadic
            struct S1< G1 > {
                @MonadicField(default: Default.self)
                @MonadicField(builder: Builder.self)
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
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self
            ]
        )
        assertMacroExpansion(
            #"""
            @Monadic
            struct S1< G1, G2 > {
                public let p1: G1
                @MonadicField(default: Default.self)
                @MonadicField(builder: Builder.self)
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
            
                @inlinable public init(p1: G1, @Builder p2: () -> G2) {
                    self.init(p1: p1, p2: p2())
                }
            
                @inlinable public init(p1: G1) where G2 == Default {
                    self.init(p1: p1, p2: Default())
                }
            }
            """#,
            macros: [
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self
            ]
        )
        assertMacroExpansion(
            #"""
            @Monadic
            struct S1< G1, G2 > {
                @MonadicField(default: Default.self)
                @MonadicField(builder: Builder.self)
                public let p1: G1
                @MonadicField(default: Default.self)
                @MonadicField(builder: Builder.self)
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
                "Monadic": ExpansionMacro.self,
                "MonadicField": DummyMacro.self
            ]
        )
    }
     
}

#endif
