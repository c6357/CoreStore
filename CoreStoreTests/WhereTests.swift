//
//  WhereTests.swift
//  CoreStore
//
//  Copyright © 2016 John Rommel Estropia
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import XCTest

@testable
import CoreStore


//MARK: - WhereTests

final class WhereTests: XCTestCase {
    
    @objc
    dynamic func test_ThatWhereClauses_ConfigureCorrectly() {
        
        do {
            
            let whereClause = Where()
            XCTAssertEqual(whereClause, Where(true))
            XCTAssertNotEqual(whereClause, Where(false))
            XCTAssertEqual(whereClause.predicate, NSPredicate(value: true))
        }
        do {
            
            let whereClause = Where(true)
            XCTAssertEqual(whereClause, Where())
            XCTAssertNotEqual(whereClause, Where(false))
            XCTAssertEqual(whereClause.predicate, NSPredicate(value: true))
        }
        do {
            
            let predicate = NSPredicate(format: "%K == %@", "key", "value")
            let whereClause = Where(predicate)
            XCTAssertEqual(whereClause, Where(predicate))
            XCTAssertEqual(whereClause.predicate, predicate)
        }
        do {
            
            let whereClause = Where("%K == %@", "key", "value")
            let predicate = NSPredicate(format: "%K == %@", "key", "value")
            XCTAssertEqual(whereClause, Where(predicate))
            XCTAssertEqual(whereClause.predicate, predicate)
        }
        do {
            
            let whereClause = Where("%K == %@", argumentArray: ["key", "value"])
            let predicate = NSPredicate(format: "%K == %@", "key", "value")
            XCTAssertEqual(whereClause, Where(predicate))
            XCTAssertEqual(whereClause.predicate, predicate)
        }
        do {
            
            let whereClause = Where("key", isEqualTo: "value")
            let predicate = NSPredicate(format: "%K == %@", "key", "value")
            XCTAssertEqual(whereClause, Where(predicate))
            XCTAssertEqual(whereClause.predicate, predicate)
        }
        do {
            
            let whereClause = Where("key", isMemberOf: ["value1", "value2", "value3"])
            let predicate = NSPredicate(format: "%K IN %@", "key", ["value1", "value2", "value3"])
            XCTAssertEqual(whereClause, Where(predicate))
            XCTAssertEqual(whereClause.predicate, predicate)
        }
    }
    
    @objc
    dynamic func test_ThatWhereClauseOperations_ComputeCorrectly() {
        
        let whereClause1 = Where("key1", isEqualTo: "value1")
        let whereClause2 = Where("key2", isEqualTo: "value2")
        let whereClause3 = Where("key3", isEqualTo: "value3")
        
        do {
            
            let notWhere = !whereClause1
            let notPredicate = NSCompoundPredicate(
                type: .NotPredicateType,
                subpredicates: [whereClause1.predicate]
            )
            XCTAssertEqual(notWhere.predicate, notPredicate)
            XCTAssertEqual(notWhere, !whereClause1)
        }
        do {
            
            let andWhere = whereClause1 && whereClause2 && whereClause3
            let andPredicate = NSCompoundPredicate(
                type: .AndPredicateType,
                subpredicates: [
                    NSCompoundPredicate(
                        type: .AndPredicateType,
                        subpredicates: [whereClause1.predicate, whereClause2.predicate]
                    ),
                    whereClause3.predicate
                ]
            )
            XCTAssertEqual(andWhere.predicate, andPredicate)
            XCTAssertEqual(andWhere, whereClause1 && whereClause2 && whereClause3)
        }
        do {
            
            let orWhere = whereClause1 || whereClause2 || whereClause3
            let orPredicate = NSCompoundPredicate(
                type: .OrPredicateType,
                subpredicates: [
                    NSCompoundPredicate(
                        type: .OrPredicateType,
                        subpredicates: [whereClause1.predicate, whereClause2.predicate]
                    ),
                    whereClause3.predicate
                ]
            )
            XCTAssertEqual(orWhere.predicate, orPredicate)
            XCTAssertEqual(orWhere, whereClause1 || whereClause2 || whereClause3)
        }
    }
    
    @objc
    dynamic func test_ThatWhereClauses_ApplyToFetchRequestsCorrectly() {
        
        let whereClause = Where("key", isEqualTo: "value")
        let request = CoreStoreFetchRequest()
        whereClause.applyToFetchRequest(request)
        XCTAssertNotNil(request.predicate)
        XCTAssertEqual(request.predicate, whereClause.predicate)
    }
}
