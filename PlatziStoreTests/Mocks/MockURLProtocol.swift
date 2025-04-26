//
//  MockURLProtocol.swift
//  PlatziStoreTests
//
//  Created by mac on 12/04/25.
//

import Foundation
import CoreData

class MockURLProtocol: URLProtocol {
    static var stubResponseData: Data?
    static var responseError: Error?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            let data = MockURLProtocol.stubResponseData ?? Data()
            
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        }
    }

    override func stopLoading() {}
    
    
}

class FailingSaveContext: NSManagedObjectContext {
    init() {
        super.init(concurrencyType: .mainQueueConcurrencyType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func save() throws {
        throw NSError(domain: "CoreData", code: 999, userInfo: [NSLocalizedDescriptionKey: "Save failed"])
    }
}
