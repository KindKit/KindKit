//
//  KindKit
//

import Foundation

public extension InputSuggestion {
    
    final class DataSource< InputType, ResponseType : IApiResponse > : IInputSuggestion {
        
        public let prepare: (String) -> InputType?
        public let dataSource: KindKit.DataSource.Action.Api< InputType, ResponseType >

        public init(
            provider: KindKit.Api.Provider,
            prepare: @escaping (String) -> InputType?,
            request: @escaping (InputType) throws -> KindKit.Api.Request,
            response: @escaping (InputType) -> ResponseType
        ) {
            self.prepare = prepare
            self.dataSource = .init(
                provider: provider,
                request: request,
                response: response
            )
        }
        
        public func autoComplete(_ text: String) -> String? {
            return nil
        }
        
        public func variants(_ text: String, completed: @escaping ([String]) -> Void) -> ICancellable? {
            guard let input = self.prepare(text) else { return nil }
            self.dataSource.perform(params: input)
            return self.dataSource
        }
        
    }
    
}
