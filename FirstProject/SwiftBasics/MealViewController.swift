//
//  ViewController.swift
//  SwiftBasics
//
//  Created by adhirajs on 12/10/17.
//  Copyright © 2017 vishalb. All rights reserved.
//

import UIKit

import os.log

import Alamofire

class MealViewController: UIViewController , UITextFieldDelegate , UIImagePickerControllerDelegate , UINavigationControllerDelegate
{

    @IBOutlet weak var saveMealButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var customStarView: CustomStarView!

    @IBOutlet weak var photoImageView: UIImageView!
    
    var meal : Meals?
    
    
    @IBAction func cancelMealButton(_ sender: Any) {
        
        let isPresentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveMealButton.isEnabled = false
    }
    
    // This method called after textFieldShouldReturn
    func textFieldDidEndEditing(_ textField: UITextField) {
        //set the value of label
        
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
        
        if let meal = meal {
            navigationItem.title = meal.name
            nameTextField.text   = meal.name
            photoImageView.image = meal.photo
            customStarView.rating = meal.rating
        }
        updateSaveButtonState()
        getAllMovieList()
    }
    
    private func getAllMovieList(){
        //  http://www.omdbapi.com/?s=all&apikey=2f1f995d
        let strURL = "http://www.omdbapi.com/"
        let param = ["s": "all", "apikey": "2f1f995d"]
        // Alamofire.request(strURL, method: .GET, parameters: param, encoding:.UTF8, headers: nil).responseJSON(completionHandler: <#T##(DataResponse<Any>) -> Void#>)
        
        Alamofire.request( URL(string: strURL)!, method: .get, parameters: param) .validate() .responseJSON {
            (response) -> Void in
            guard response.result.isSuccess
                else {
                    print("Error while fetching remote rooms: \(response.result.error)")
                    return
            }
            print(response.result.value!)
            guard let value = response.result.value as? [String: Any], let rows = value["rows"] as? [[String: Any]] else {
                print("Malformed data received from fetchAllRooms service")
                return
                
            }
        }
    }
    
    

   
    @IBAction func showImagePicker(_ sender: UITapGestureRecognizer) {
        
        // HIde Keyboard
        
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
     //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        photoImageView.image = selectedImage
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveMealButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let image = photoImageView.image
        let rating = customStarView.rating
        
        meal = Meals(name: name, photo: image, rating: rating)
    }
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveMealButton.isEnabled = !text.isEmpty
    }
}

