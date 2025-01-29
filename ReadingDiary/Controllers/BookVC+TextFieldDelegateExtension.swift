//
//  BookVC+TextFieldDelegateExtension.swift
//  ReadingDiary
//
//  Created by Anna Panova on 29.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

extension BookVC: UITextFieldDelegate {
    //  MARK:  Setup textFieldDelegate
    
    func setupTextFieldDelegate() {
        titleTextField.delegate = self
        authorTextField.delegate = self
        myStarsTextField.delegate = self
        startOfReadingTextField.delegate = self
        endOfReadingTextField.delegate = self
    }
    
    //  MARK:  Dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //  MARK:  Setup gestureRecognizer for dismissing number keyboard
    func setupGestRecognizer() {
        let gestRecognizer = UITapGestureRecognizer()
        gestRecognizer.addTarget(self, action: #selector(didTapView))
        view.addGestureRecognizer(gestRecognizer)
    }
    
    //  Dismiss number keyboard
    @objc func didTapView() {
        view.endEditing(true)
    }
    
    //  MARK: Checking the count of stars
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //  array with acceptable value of stars
        let starsArray = ["0","1","2","3","4","5"]
        if textField == myStarsTextField {
            //  number of stars is in acceptable values
            if starsArray.contains(textField.text!) {
                myStarsTextField.text = textField.text! + ".0"
            } else {
                //  number of stars is out acceptable value
                myStarsTextField.text = nil
                let alertController = UIAlertController(title: "Is there something wrong...", message: "The count of stars must be from 0 to 5 ", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(alertAction)
                present(alertController, animated: true, completion: nil)
            }
        }
        return true
    }
}

