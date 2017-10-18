//
//  CustomStarView.swift
//  SwiftBasics
//
//  Created by adhirajs on 17/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit

@IBDesignable class CustomStarView: UIStackView {
    

    //MARK: Properties
    private var ratingButtons = [UIButton]()
    var rating = 0
    {
        didSet {
            updateButtonSelectionStates()
        }
    }
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0)
    {
        
        didSet
        {
            setUpButtons()
        }
    }
    @IBInspectable var starCount: Int = 5
    {
        
        didSet
        {
            setUpButtons()
        }
    }
    
    //MARK: Initialixation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpButtons()
    }
    
    required init(coder: NSCoder) {

        super.init(coder: coder)
        setUpButtons()
    }
    
    
    //MARK: private buttons
    
   private func setUpButtons () {
    
    // clear any existing buttons
    for button in ratingButtons {
        removeArrangedSubview(button)
        button.removeFromSuperview()
    }
    ratingButtons.removeAll()
    
    
    // Load Button Images
    let bundle = Bundle(for: type(of: self))
    let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
    let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
    let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
    
    
    for index in 0..<starCount
    {
        
        let firstButton = UIButton ()
        

        //set star images
        firstButton.setImage(emptyStar, for: .normal)
        firstButton.setImage(filledStar, for: .selected)
        firstButton.setImage(highlightedStar, for: .highlighted)
        firstButton.setImage(highlightedStar, for: [.highlighted, .selected])
        
    // Add constraints
    firstButton.translatesAutoresizingMaskIntoConstraints = false
    firstButton.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
    firstButton.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
        firstButton.accessibilityLabel = "Set \(index + 1) star rating"

    firstButton.addTarget(self, action: #selector(CustomStarView.ratingButtonTapped(button:)), for: .touchUpInside)
    
    addArrangedSubview(firstButton)
        
    ratingButtons.append(firstButton)
    
    }
    updateButtonSelectionStates()

    }
    
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
            
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
        
    }
    
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected.
            button.isSelected = index < rating
            
            // Set the hint string for the currently selected star
            let hintString: String?
            if rating == index + 1 {
                hintString = "Tap to reset the rating to zero."
            } else {
                hintString = nil
            }
            
            // Calculate the value string
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            
            // Assign the hint string and value string
            button.accessibilityHint = hintString
            button.accessibilityValue = valueString
        }
    }
    
    
    
}
