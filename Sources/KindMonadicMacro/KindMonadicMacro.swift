//
//  KindKit
//

@attached(member)
@attached(extension, names: arbitrary)
public macro KindMonadic() = #externalMacro(module: "KindMonadicMacroPlugin", type: "ExpansionMacro")

@attached(peer)
public macro KindMonadicProperty() = #externalMacro(module: "KindMonadicMacroPlugin", type: "DummyMacro")

@attached(peer)
public macro KindMonadicProperty(alias: String) = #externalMacro(module: "KindMonadicMacroPlugin", type: "DummyMacro")

@attached(peer)
public macro KindMonadicSignal() = #externalMacro(module: "KindMonadicMacroPlugin", type: "DummyMacro")
