//
//  ValidationTest.swift
//  TowkDemoTests
//
//  Created by Arshdeep Singh on 13/08/21.
//

import XCTest
@testable import TowkDemo

class ValidationTest: XCTestCase {
    
    private var webClient : ApiClient!
    
    override func setUp() {
        super.setUp()
        webClient = ApiClient()
    }
    
    override func tearDown() {
        webClient = nil
        super.tearDown()
        
    }
    
    func testSaveUserListData() throws {
        XCTAssertTrue(ApplicationSession.isOnline())
    }
    

}
