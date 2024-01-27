//
//  KindKit
//

@attached(member, names: arbitrary)
@attached(extension, names: arbitrary)
public macro Monadic() = #externalMacro(
    module: "KindMonadicMacroPlugin",
    type: "ExpansionMacro"
)

@attached(peer)
public macro MonadicField() = #externalMacro(
    module: "KindMonadicMacroPlugin",
    type: "DummyMacro"
)

@attached(peer)
public macro MonadicField< Default >(
    default: Default.Type
) = #externalMacro(
    module: "KindMonadicMacroPlugin",
    type: "DummyMacro"
)

@attached(peer)
public macro MonadicField< Builder >(
    builder: Builder.Type
) = #externalMacro(
    module: "KindMonadicMacroPlugin",
    type: "DummyMacro"
)

@attached(peer)
public macro MonadicField(
    alias: String
) = #externalMacro(
    module: "KindMonadicMacroPlugin",
    type: "DummyMacro"
)

@attached(peer)
public macro MonadicSignal() = #externalMacro(
    module: "KindMonadicMacroPlugin", 
    type: "DummyMacro"
)
