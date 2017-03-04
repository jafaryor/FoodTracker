//
//  RatingControl.swift
//  FoodTracker
//
//  Created by Jafar Yormahmadzoda on 23/02/2017.
//  Copyright © 2017 Jafar Yormahmadzoda. All rights reserved.
//

import UIKit

// Interface Builder does not know anything about the contents of your rating control. To fix this, you define the control as @IBDesignable. This lets Interface Builder instantiate and draw a copy of your control directly in the canvas
@IBDesignable class RatingControl: UIStackView {
    // MARK: Properties
    // Interface Builder can do more than just display your custom view. You can also specify properties that can then be set in the Attributes inspector. Add the @IBInspectable attribute to the desired properties
    private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet {
            updateButtonSelectionStates()
        }
    }
    // To update the control, you need to reset the control’s buttons every time these attributes change. To do that, add a property observer to each property
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        // didSet property observer is called immediately after the property’s value is set
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: Button Action
    func ratingButtonTapped(button: UIButton) {
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
    
    // MARK: Private Methods
    private func setupButtons() {
        // clear any existing buttons
        for button in ratingButtons {
            removeArrangedSubview(button) //removes the button from the list of views managed by the stack view. This tells the stack view that it should no longer calculate the button’s size and position—but the button is still a subview of the stack view
            button.removeFromSuperview() //removes the button from the stack view entirely
        }
        ratingButtons.removeAll()
        
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named:"emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named:"highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            // Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
        
            // Add constraints
            button.translatesAutoresizingMaskIntoConstraints = false //disables the button’s automatically generated constraints. When you programmatically instantiate a view, its translatesAutoresizingMaskIntoConstraints property defaults to true. This tells the layout engine to create constraints that define the view’s size and position based on the view’s frame and autoresizingmask properties
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
                // Set the accessibility label
                button.accessibilityLabel = "Set \(index + 1) star rating"
            
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            /*
             self - refers to the current instance of the enclosing class
             #selector - returns the Selector value for the provided method
             #selector(RatingControl.ratingButtonTapped(_:)) - returns the selector for your ratingButtonTapped(_:) action method. This lets the system call your action method when the button is tapped
             touchUpInside - event which button listenes to
             */
            
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
        
        updateButtonSelectionStates()
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

/*
 When the user runs your app with VoiceOver enabled, when they touch one of the buttons, VoiceOver reads the button’s label, followed by the word button. Then it reads the accessibility value. Finally, it reads the accessibility hint (if any). This lets the user know both the control’s current value and the result of tapping the currently selected button.
 Accessibility label. A short, localized word or phrase that succinctly describes the control or view, but does not identify the element’s type. Examples are “Add” or “Play.”
 Accessibility value. The current value of an element, when the value is not represented by the label. For example, the label for a slider might be “Speed,” but its current value might be “50%.”
 Accessibility hint. A brief, localized phrase that describes the results of an action on an element. Examples are “Adds a title” or “Opens the shopping list.”
 */
