//
//  APIClientsTests.swift
//  ToDo
//
//  Created by g tokman on 12/25/16.
//  Copyright © 2016 garytokman. All rights reserved.
//

import XCTest
@testable import ToDo

class APIClientsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func test_Login_UsesExpectedURL() {
        let sut = APIClient()
        
        let mockURLSession = MockURLSession(data: nil, urlResponse: nil, error: nil)
        
        sut.session = mockURLSession
        
        let completion = { (token: Token?, error: Error?) in }
        sut.loginUser(withName: "dasdöm", password: "%&34", completion: completion)
        
        guard let url = mockURLSession.url else {
            XCTFail()
            return
        }
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        XCTAssertEqual(urlComponents?.host, "awesometodos.com")
        XCTAssertEqual(urlComponents?.path, "/login")
        
        let allowedCharacters = CharacterSet(
            charactersIn: "/%&=?$#+-~@<>|\\*,.()[]{}^!").inverted
        
        // TODO: Add test for url 
        /*
         Right now the test depends on the order of the query items. This is not a good idea because in a URL, the order is irrelevant. This means the test could fail even if the URL is correct. So you should refactor the test before you proceed with the next test. Hint: URLComponents has a property called queryItems. This should help.
         */
        
        guard let expectedUsername = "dasdöm".addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        
        guard let expectedPassword = "%&34".addingPercentEncoding(
            withAllowedCharacters: allowedCharacters) else { fatalError() }
        
        XCTAssertEqual(urlComponents?.percentEncodedQuery,
                       "username=\(expectedUsername)&password=\(expectedPassword)")
     
    }
    
    func test_Login_WhenSuccessful_CreatesToken() {
        
        
        let sut = APIClient()
        let jsonData = "{\"token\":\"1234567890\"}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData,
                                            urlResponse: nil,
                                            error: nil)
        sut.session = mockURLSession
        
        
        let tokenExpectation = expectation(description: "Token")
        var catchedToken: Token? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedToken = token
            tokenExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 1) { (error) in 
            XCTAssertEqual(catchedToken?.id, "1234567890") 
        } 
    }
    
    func test_Login_WhenJSONIsInvalid_ReturnsError() {
        
        
        let sut = APIClient()
        let mockURLSession = MockURLSession(data: Data(),
                                            urlResponse: nil,
                                            error: nil)
        sut.session = mockURLSession
        
        
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 1) { (error) in 
            XCTAssertNotNil(catchedError) 
        } 
    }
    
    func test_Login_WhenDataIsNil_ReturnsError() {
        
        
        let sut = APIClient()
        let mockURLSession = MockURLSession(data: nil,
                                            urlResponse: nil,
                                            error: nil)
        sut.session = mockURLSession
        
        
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedError = error
            errorExpectation.fulfill()
        }
        
        
        waitForExpectations(timeout: 1) { (error) in 
            XCTAssertNotNil(catchedError) 
        } 
    }
    
    func test_Login_WhenResponseHasError_ReturnsError() {
        
        
        let sut = APIClient()
        let error = NSError(domain: "SomeError",
                            code: 1234,
                            userInfo: nil)
        let jsonData = "{\"token\":\"1234567890\"}".data(using: .utf8)
        let mockURLSession = MockURLSession(data: jsonData,
                                            urlResponse: nil,
                                            error: error)
        sut.session = mockURLSession
        
        
        let errorExpectation = expectation(description: "Error")
        var catchedError: Error? = nil
        sut.loginUser(withName: "Foo", password: "Bar") { (token, error) in
            catchedError = error
            errorExpectation.fulfill()
        } 
        
        
        waitForExpectations(timeout: 1) { (error) in 
            XCTAssertNotNil(catchedError) 
        } 
    }
  
}

extension APIClientsTests {
    class MockURLSession: SessionProtocol {
        var url: URL?
        private let dataTask: MockTask
        
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            dataTask = MockTask(data: data,
                                urlResponse: urlResponse,
                                error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            self.url = url
            dataTask.completionHandler = completionHandler
            return dataTask
        }
    }
    
    class MockTask: URLSessionDataTask {
        private let data: Data?
        private let urlResponse: URLResponse?
        private let responseError: Error?
        
        
        typealias CompletionHandler = (Data?, URLResponse?, Error?)
            -> Void
        var completionHandler: CompletionHandler?
        
        
        init(data: Data?, urlResponse: URLResponse?, error: Error?) {
            self.data = data
            self.urlResponse = urlResponse
            self.responseError = error
        }
        
        
        override func resume() {
            DispatchQueue.main.async() {
                self.completionHandler?(self.data,
                                        self.urlResponse, 
                                        self.responseError) 
            } 
        } 
    }
}
