//
//  MealViewController.swift
//  FoodTracker
//
//  Created by Jafar Yormahmadzoda on 23/01/2017.
//  Copyright © 2017 Jafar Yormahmadzoda. All rights reserved.
//

import UIKit
import os.log
// os.log - imports the unified logging system. Like the print() function, the unified logging system lets you send messages to the console. However, the unified logging system gives you more control over when messages appear and how they are saved

class MealViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: Properties
    // Outlets let you refer to your interface elements in code
    @IBOutlet weak var nameTextField: UITextField!
    /*
     The IBOutlet attribute tells Xcode that you can connect to the nameTextField property from Interface Builder (which is why the attribute has the IB prefix)
     The weak keyword indicates that the reference does not prevent the system from deallocating the referenced object
     Pay careful attention to the exclamation point at the end of the type declaration. This exclamation point indicates that the type is an implicitly unwrapped optional, which is an optional type that will always have a value after it is first set. When you access an implicitly unwrapped optional, the system assumes it has a valid value and automatically unwraps it for you
     */
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    /*
     This value is either passed by `MealTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new meal.
     */
    var meal: Meal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Handle the text field’s user input through delegate callbacks
        nameTextField.delegate = self
        // When a ViewController instance is loaded, it sets itself as the delegate of its nameTextField property.
        
        // Set up views if editing an existing Meal.
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            ratingControl.rating = meal.rating
        }
        
        // Enable the Save button only if the text field has a valid Meal name.
        updateSaveButtonState()
    }
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            // Dismisses the modal scene and animates the transition back to the previous scene
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController {
            // called if the user is editing an existing meal
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    // Called before any segue gets executed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        // Whenever a segue gets triggered, it provides a place for you to add your own code that gets executed. This method is called prepare(for:sender:), and it gives you a chance to store data and do any necessary cleanup
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        meal = Meal(name: name, photo: photo, rating: rating)
    }
    
    
    
    // MARK: Actions
    // Gesture recognizers are objects that you attach to a view that allow the view to respond to the user the way a control does.
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        /*
         sender parameter refers to the object that was responsible for triggering the action—in this case, a button.
         IBAction attribute indicates that the method is an action that you can connect to from your storyboard in Interface Builder
         */
        
        // Hide the keyboard
        nameTextField.resignFirstResponder()
        // UIImagePickerController is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        // Only allow photos to be picked, not taken
        imagePickerController.sourceType = .photoLibrary
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        // present() - method asks ViewController to present the view controller defined by imagePickerController
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: UITextFieldDelegate
    // Gets called when the user taps Return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    // Called after the text field resigns its first-responder status
    func textFieldDidEndEditing(_ textField: UITextField) {
        // This method gives you a chance to read the information entered into the text field and do something with it
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    // Called when an editing session begins, or when the keyboard gets displayed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    // MARK: UIImagePickerControllerDelegate
    // Gets called when a user taps the image picker’s Cancel button
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    // Gets called when a user selects a photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary always contains the original image that was selected in the picker
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
}

// All view objects in iOS are of type UIView or one of its subclasses
/*
 Weak references help prevent reference cycles; however, to keep the object alive and in memory you need to make sure some other part of your app has a strong reference to the object. In this case, it’s the text field’s superview. A superview maintains a strong reference to all of its subviews. As long as the superview remains alive and in memory, all of the subviews remain alive as well. Similarly, the view controller has a strong reference to its content view—keeping the entire view hierarchy alive and in memory.
 The behavior that just implemented is an example of the target-action pattern in iOS app design. Target-action is a design pattern where one object sends a message to another object when a specific event occurs.
 When you work with accepting user input from a text field, you need some help from a text field delegate. A delegate is an object that acts on behalf of, or in coordination with, another object. The delegating object—in this case, the text field—keeps a reference to the other object—the delegate—and at the appropriate time, the delegating object sends a message to the delegate. The message tells the delegate about an event that the delegating object is about to handle or has just handled. The delegate may respond by for example, updating the appearance or state of itself or of other objects in the app, or returning a value that affects how an impending event is handled.
 A text field’s delegate communicates with the text field while the user is editing the text, and knows when important events occur—such as when a user starts or stops editing text. The delegate can use this information to save or clear data at the right time, dismiss the keyboard, and so on.
 Any object can serve as a delegate for another object as long as it conforms to the appropriate protocol. The protocol that defines a text field’s delegate is called UITextFieldDelegate. It is very common to make a view controller the delegate for objects that it manages. In this case, you’ll make your ViewController instance the text field’s delegate. That is why we adopt UITextFieldDelegate protocol.
 By adopting the UITextFieldDelegate protocol, you tell the compiler that the ViewController class can act as a valid text field delegate. This means you can implement the protocol’s methods to handle text input, and you can assign instances of the ViewController class as the delegate of the text field.
 
 An object of the UIViewController class (and its subclasses) comes with a set of methods that manage its view hierarchy. iOS automatically calls these methods at appropriate times when a view controller transitions between states. When you create a view controller subclass (like the ViewController class you’ve been working with), it inherits the methods defined in UIViewController and lets you add your own custom behavior for each method. It’s important to understand when the system calls these methods, so you can set up or tear down the views you’re displaying at the appropriate step in the process—something you’ll need to do later in the lessons.
 iOS calls the UIViewController methods as follows:
 viewDidLoad()—Called when the view controller’s content view (the top of its view hierarchy) is created and loaded from a storyboard. The view controller’s outlets are guaranteed to have valid values by the time this method is called. Use this method to perform any additional setup required by your view controller.
 Typically, iOS calls viewDidLoad() only once, when its content view is first created; however, the content view is not necessarily created when the controller is first instantiated. Instead, it is lazily created the first time the system or any code accesses the controller’s view property.
 viewWillAppear()—Called just before the view controller’s content view is added to the app’s view hierarchy. Use this method to trigger any operations that need to occur before the content view is presented onscreen. Despite the name, just because the system calls this method, it does not guarantee that the content view will become visible. The view may be obscured by other views or hidden. This method simply indicates that the content view is about to be added to the app’s view hierarchy.
 viewDidAppear()—Called just after the view controller’s content view has been added to the app’s view hierarchy. Use this method to trigger any operations that need to occur as soon as the view is presented onscreen, such as fetching data or showing an animation. Despite the name, just because the system calls this method, it does not guarantee that the content view is visible. The view may be obscured by other views or hidden. This method simply indicates that the content view has been added to the app’s view hierarchy.
 This style of app design where view controllers serve as the communication pipeline between your views and your data model is known as MVC (Model-View-Controller)
 */
