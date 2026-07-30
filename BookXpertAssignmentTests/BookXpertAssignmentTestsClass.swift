//
//  BookXpertAssignmentTestsClass.swift
//  BookXpertAssignmentTests
//
//  Created by Avinash Verma on 30/07/26.
//

import XCTest

@testable import BookXpertAssignment

final class BookXpertAssignmentTestsClass: XCTestCase {

    func testAddition() {
        XCTAssertEqual(2 + 2, 4)
    }
    
    func testAutoBuild() {
        XCTAttachment(string: "Successfully Auto build Done")
    }
}
