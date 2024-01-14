//
//  TestMacro
//

#if os(macOS)

import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import KindMonadicMacroPlugin

final class TestExpand : XCTestCase {
    
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
            
                public func p1(_ value: String) -> Self {
                    return .init(p1: value, p2: self.p2)
                }
            
                public func p2(_ value: String) -> Self {
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
                let s1: Signal.Empty< Void >
                @KindMonadicSignal
                let s2 = Signal.Empty< Void >()
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
                let s1: Signal.Empty< Void >
                let s2 = Signal.Empty< Void >()
            
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
            
                @discardableResult func p1(_ value: () -> Bool) -> Self {
                    self.p1 = value()
                    return self
                }
            
                @discardableResult func p1(_ value: (Self) -> Bool) -> Self {
                    self.p1 = value(self)
                    return self
                }
            
                @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
            
                @discardableResult func p3(_ value: () -> Int) -> Self {
                    self.p3 = value()
                    return self
                }
            
                @discardableResult func p3(_ value: (Self) -> Int) -> Self {
                    self.p3 = value(self)
                    return self
                }
            
                @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
            
                @discardableResult func a2(_ value: () -> Int) -> Self {
                    self.a2 = value()
                    return self
                }
            
                @discardableResult func a2(_ value: (Self) -> Int) -> Self {
                    self.a2 = value(self)
                    return self
                }
            
                @discardableResult func onS1(_ closure: @escaping() -> Void) -> Self {
                    self.s1.on(closure)
                    return self
                }
            
                @discardableResult func onS1(_ closure: @escaping(Self) -> Void) -> Self {
                    self.s1.on(self, closure)
                    return self
                }
            
                @discardableResult func onS1<Sender>(_ sender: Sender, _ closure: @escaping(Sender) -> Void) -> Self where Sender: AnyObject {
                    self.s1.on(sender, closure)
                    return self
                }
            
                @discardableResult func unS1(_ sender: AnyObject) -> Self {
                    self.s1.un(sender)
                    return self
                }
            
                @discardableResult func onS2(_ closure: @escaping() -> Void) -> Self {
                    self.s2.on(closure)
                    return self
                }
            
                @discardableResult func onS2(_ closure: @escaping(Self) -> Void) -> Self {
                    self.s2.on(self, closure)
                    return self
                }
            
                @discardableResult func onS2<Sender>(_ sender: Sender, _ closure: @escaping(Sender) -> Void) -> Self where Sender: AnyObject {
                    self.s2.on(sender, closure)
                    return self
                }
            
                @discardableResult func unS2(_ sender: AnyObject) -> Self {
                    self.s2.un(sender)
                    return self
                }
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
            
                @discardableResult func p1(_ value: () -> T) -> Self {
                    self.p1 = value()
                    return self
                }
            
                @discardableResult func p1(_ value: (Self) -> T) -> Self {
                    self.p1 = value(self)
                    return self
                }
            
                @discardableResult func p2(_ value: T) -> Self {
                    self.p2 = value
                    return self
                }
            
                @discardableResult func p2(_ value: () -> T) -> Self {
                    self.p2 = value()
                    return self
                }
            
                @discardableResult func p2(_ value: (Self) -> T) -> Self {
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
                var s1: Signal.Empty< Void > { set get }
                @KindMonadicSignal
                var s2: Signal.Empty< Void > { set get }
            }
            """#,
            expandedSource: #"""
            protocol P1 {
                var p1: Bool { set get }
                var p2: Int { get }
                var p3: Int { set get }
                var s1: Signal.Empty< Void > { set get }
                var s2: Signal.Empty< Void > { set get }
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
                @discardableResult func p1(_ value: () -> Bool) -> Self {
                    self.p1 = value()
                    return self
                }
                @discardableResult func p1(_ value: (Self) -> Bool) -> Self {
                    self.p1 = value(self)
                    return self
                }
                @discardableResult func p3(_ value: Int) -> Self {
                    self.p3 = value
                    return self
                }
                @discardableResult func p3(_ value: () -> Int) -> Self {
                    self.p3 = value()
                    return self
                }
                @discardableResult func p3(_ value: (Self) -> Int) -> Self {
                    self.p3 = value(self)
                    return self
                }
                @discardableResult func a2(_ value: Int) -> Self {
                    self.a2 = value
                    return self
                }
                @discardableResult func a2(_ value: () -> Int) -> Self {
                    self.a2 = value()
                    return self
                }
                @discardableResult func a2(_ value: (Self) -> Int) -> Self {
                    self.a2 = value(self)
                    return self
                }
                @discardableResult func onS1(_ closure: @escaping() -> Void) -> Self {
                    self.s1.on(closure)
                    return self
                }
                @discardableResult func onS1(_ closure: @escaping(Self) -> Void) -> Self {
                    self.s1.on(self, closure)
                    return self
                }
                @discardableResult func onS1<Sender>(_ sender: Sender, _ closure: @escaping(Sender) -> Void) -> Self where Sender: AnyObject {
                    self.s1.on(sender, closure)
                    return self
                }
                @discardableResult func unS1(_ sender: AnyObject) -> Self {
                    self.s1.un(sender)
                    return self
                }
                @discardableResult func onS2(_ closure: @escaping() -> Void) -> Self {
                    self.s2.on(closure)
                    return self
                }
                @discardableResult func onS2(_ closure: @escaping(Self) -> Void) -> Self {
                    self.s2.on(self, closure)
                    return self
                }
                @discardableResult func onS2<Sender>(_ sender: Sender, _ closure: @escaping(Sender) -> Void) -> Self where Sender: AnyObject {
                    self.s2.on(sender, closure)
                    return self
                }
                @discardableResult func unS2(_ sender: AnyObject) -> Self {
                    self.s2.un(sender)
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
     
}

#endif
