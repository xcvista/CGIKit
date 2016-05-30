//
//  CGIRequestTestSwift.swift
//  CGIKit
//
//  Created by Maxthon Chan on 5/28/16.
//  Copyright © 2016 DreamCity. All rights reserved.
//

import XCTest
import CGIKit

class CGIRequestTestSwift: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let data = NSData.init();
        let request = CGIRequest.init(requestLine: "GET / HTTP/1.0", headerFields: [:], inputStream: NSInputStream.init(data: data))
        XCTAssert(request.method == "GET")
        XCTAssert(request.requestURI == "/")
        XCTAssert(request.protocolVersion == "HTTP/1.0")
    }

}
