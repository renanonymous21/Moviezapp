//
//  RequestErrorTests.swift
//  MoviezappTests
//
//  Created by Rendy K. R on 13/03/21.
//

import XCTest

class RequestErrorTests: XCTestCase {

    func apiRequest(_ useCase: StubErrorUseCase) {
        let expectation = self.expectation(description: "Request Failed")
        APIManager.request(useCase) { (result: Result<EmptyModel, RuntimeError>) in
            do {
                _ = try result.get()
                XCTFail("Should not happened")
            } catch {
                print(error)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testingEndpointNotFound() throws {
        apiRequest(StubErrorUseCase.testEndpointNotFound)
    }
    
    func testingWrongApiKey() throws {
        apiRequest(StubErrorUseCase.testWrongApiKey)
    }
}
