//
//  LiftBroTests.swift
//  LiftBroTests
//
//  Created by Ari Gold on 5/29/17.
//  Copyright © 2017 Ari Gold. All rights reserved.
//

import XCTest
@testable import LiftBro

class LiftBroTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
         // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let training = Training()
        training.date = Date() as NSDate?
        _ = training.dateWithoutTime
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
