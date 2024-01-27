//
//  KindMacro
//

import Foundation

import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftDiagnostics

public struct PathMacro : ExpressionMacro {
    
    public enum Error : Swift.Error {
        
        case `internal`
        case emptyArgument
        case invalidArgumentType
        case unsupportedSyntax
        
    }
    
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {
        guard node.arguments.count > 0 else {
            throw Error.emptyArgument
        }
        let arrayExpr = try ArrayExprSyntax(elementsBuilder: {
            for argument in node.arguments {
                if let argument = argument.expression.as(StringLiteralExprSyntax.self) {
                    if argument.segments.count == 1 {
                        if case .stringSegment(let literalSegment) = argument.segments.first {
                            ArrayElementSyntax(
                                expression: StringLiteralExprSyntax(content: literalSegment.content.text)
                            )
                        } else {
                            throw Error.invalidArgumentType
                        }
                    } else {
                        throw Error.invalidArgumentType
                    }
                } else if let argument = argument.expression.as(IntegerLiteralExprSyntax.self) {
                    ArrayElementSyntax(
                        expression: IntegerLiteralExprSyntax(literal: argument.literal)
                    )
                } else {
                    throw Error.invalidArgumentType
                }
            }
        })
        return ExprSyntax(
            FunctionCallExprSyntax(
                callee: MemberAccessExprSyntax(
                    base: DeclReferenceExprSyntax(
                        baseName: .identifier("KindJSONPath")
                    ),
                    declName: DeclReferenceExprSyntax(
                        baseName: .identifier("Path")
                    )
                ),
                argumentList: {
                    LabeledExprSyntax(
                        expression: arrayExpr
                    )
                }
            )
        )
    }
    
}
