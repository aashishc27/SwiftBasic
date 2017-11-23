//
//  MovieDetails.swift
//  SwiftBasics
//
//  Created by adhirajs on 22/11/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit

class MovieDetails: NSObject {
    
    var Poster  : String?
   public var Title   : String
    var `Type`  : String
    var Year   : String
    var imdbID   : String

    init?(Title: String, Poster: String?,`Type`: String,Year: String,imdbID: String) {
        
        // The title must not be empty
        guard !Title.isEmpty else {
            return nil
        }
        
        // Initialize movies properties.
        self.Title = Title
        self.Poster = Poster
        self.imdbID = imdbID
        self.Year = Year
        self.`Type` = `Type`
        
    }
}

