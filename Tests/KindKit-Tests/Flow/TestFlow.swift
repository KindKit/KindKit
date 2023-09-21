//
//  KindKit-Test
//

import XCTest
import KindKit

class TestFlow : XCTestCase {
    
    func testBase() {
        let pipeline = Flow.Builder< Int, Never >()
            .map(value: { String($0) })
            .pipeline()
        pipeline.send(value: 1)
    }
    
    func testDelay() {
        let expectation = self.expectation(description: "Test")
        let pipeline = Flow.Builder< Int, Never >()
            .map(value: { String($0) })
            .delay(
                queue: .main,
                timeout: {
                    guard case .success = $0 else { return 2 }
                    return 3
                }
            )
            .pipeline()
        let subscription = pipeline.subscribe(
            onCompleted: {
                expectation.fulfill()
            }
        )
        pipeline.send(value: 1)
        pipeline.completed()
        self.wait(for: [ expectation ], timeout: 5)
        subscription.cancel()
    }
    
    func testChain() {
        let expectation = self.expectation(description: "Test")
        let pipeline = Flow.Builder< Int, Never >()
            .run(
                pipeline: Flow.Builder< Int, Never >()
                    .dispatch(global: .utility)
                    .accumulate()
                    .pipeline()
            )
            .dispatch(.main)
            .each()
            .pipeline()
        let subscription = pipeline.subscribe(
            onReceiveValue: {
                if $0 % 2 != 0 {
                    XCTFail("Invalid value \($0)")
                }
            },
            onCompleted: {
                expectation.fulfill()
            }
        )
        pipeline.send(value: 2)
        pipeline.send(value: 4)
        pipeline.send(value: 6)
        pipeline.completed()
        self.wait(for: [ expectation ], timeout: 5)
        subscription.cancel()
    }
    
    func testChain2() {
        let expectation = self.expectation(description: "Test")
        let pipeline = Flow.Builder< Int, Never >()
            .fork(
                pipeline1: Flow.Builder< Int, Never >()
                    .map(value: { $0 * 2 })
                    .pipeline(),
                pipeline2: Flow.Builder< Int, Never >()
                    .map(value: { $0 * 2 })
                    .pipeline()
            )
            .map(value: { $0.0 + $0.1 })
            .pipeline()
        let subscription = pipeline.subscribe(
            onReceiveValue: {
                if $0 != 8 {
                    XCTFail("Invalid value \($0)")
                }
            },
            onCompleted: {
                expectation.fulfill()
            }
        )
        pipeline.send(value: 2)
        pipeline.completed()
        self.wait(for: [ expectation ], timeout: 5)
        subscription.cancel()
    }
    
    func testDoit() {
        enum OneError : Error {
            case unknown
        }
        
        enum TwoError : Error {
            case unknown
            case one(OneError)
        }
        
        let pipeline = Flow.Builder< Void, OneError >()
            .map({ input -> Result< Int, TwoError > in
                switch input {
                case .success: return .success(1)
                case .failure(let error): return .failure(.one(error))
                }
            })
            .condition(
                if: {
                    switch $0 {
                    case .success(let value): return value == 1
                    case .failure: return false
                    }
                },
                then: Flow.Builder()
                    .map(value: { $0 + 1 })
                    .pipeline()
            )
            .pipeline()
        do {
            let expectation = self.expectation(description: "Test")
            let subscription = pipeline.subscribe(
                onReceiveValue: {
                    if $0 != 2 {
                        XCTFail("Invalid value \($0)")
                    }
                },
                onCompleted: {
                    expectation.fulfill()
                }
            )
            pipeline.send(value: ())
            pipeline.completed()
            self.wait(for: [ expectation ], timeout: 5)
            subscription.cancel()
        }
        do {
            let expectation = self.expectation(description: "Test")
            let subscription = pipeline.subscribe(
                onCompleted: {
                    expectation.fulfill()
                }
            )
            pipeline.send(error: .unknown)
            pipeline.completed()
            self.wait(for: [ expectation ], timeout: 5)
            subscription.cancel()
        }
    }

}
