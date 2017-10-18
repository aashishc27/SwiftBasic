//
//  Meals.swift
//  SwiftBasics
//
//  Created by adhirajs on 18/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit

class Meals {
    
    //first model
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var rating: Int
    
    init?(name: String, photo: UIImage?, rating: Int) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        
    }}
