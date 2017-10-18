//
//  SwiftBasicsTests.swift
//  SwiftBasicsTests
//
//  Created by adhirajs on 18/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import XCTest
@testable import SwiftBasics

class SwiftBasicsTests: XCTestCase {
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        // Zero rating
        let zeroRatingMeal = Meals.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Highest positive rating
        let positiveRatingMeal = Meals.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        // Negative rating
        let negativeRatingMeal = Meals.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Meals.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
    }
    
}
