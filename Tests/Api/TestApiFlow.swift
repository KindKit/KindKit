//
//  KindKitApi-Test
//

import XCTest
import KindKitApi
import KindKitFlow

class TestApiFlow : XCTestCase {
    
    func testPipeline() {
        let expectation = self.expectation(description: "Test")
        let provider = Api.Provider()
        let pipeline = Flow< String, Never >()
            .map({ input -> Result< URL, NSError > in
                switch input {
                case .success(let string):
                    guard let url = URL(string: string) else {
                        return .failure(NSError())
                    }
                    return .success(url)
                case .failure:
                    return .failure(NSError())
                }
            })
            .apiQuery(
                provider: provider,
                dispatch: .main,
                request: {
                    return .init(
                        method: .get,
                        path: .absolute($0)
                    )
                },
                response: { _ in
                    Query.Response()
                },
                transform: { _, response -> Result< Data, Query.ResponseError > in
                    switch response {
                    case .success(let value): return .success(value.0)
                    case .failure(let error): return .failure(error)
                    }
                }
            )
            .pipeline()
        let subscription = pipeline.subscribe(
            onReceiveValue: {
                if $0.isEmpty == true {
                    XCTFail("Invalid data size \($0.count)")
                }
            },
            onReceiveError: {
                XCTFail("Invalid loading \($0)")
            },
            onCompleted: {
                expectation.fulfill()
            }
        )
        pipeline.send(value: "https://images.unsplash.com/photo-1594568284297-7c64464062b1")
        self.wait(for: [ expectation ], timeout: 60 * 2)
        subscription.cancel()
    }

}

extension TestApiFlow {
    
    enum Query {
        
        enum ResponseError : Swift.Error {
            
            case invalidRequest
            case invalidResponse
            
        }
        
        struct Response : IApiResponse {
            
            typealias Success = (Data, Date)
            typealias Failure = ResponseError
            
            func parse(meta: Api.Response.Meta, data: Data?) -> Result< Success, Failure > {
                guard let data = data else {
                    return .failure(.invalidResponse)
                }
                return .success((data, Date()))
            }
            
            func parse(error: Error) -> Result< Success, Failure > {
                return .failure(.invalidResponse)
            }
            
        }
        
    }
    
}
