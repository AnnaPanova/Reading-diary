//
//  ReviewVC.swift
//  ReadingDiary
//
//  Created by Anna Panova on 18.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit

// Protocol for sending date to the BookVC
protocol BookSendingDelegateProtocol {
    func sendTheBook(book: Book, newReviewIsExist: Bool)
}

class ReviewVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    // information about book from BookVC
    var book: Book!
    
    // delegate variable is responsible to keep a track of functions and use that functions to send data to BookVC
    var protocolDelegate: BookSendingDelegateProtocol? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView()
    }
    
    //  MARK: Save review action
    @IBAction func saveAction(_ sender: UIBarButtonItem) {
        
        if protocolDelegate != nil {
            if reviewTextView.text != "" {
                //  review is exist
                book.review = reviewTextView.text
            } else {
                //  review is nil
                book.review = nil
            }
        }
        //  saving the changes in CoreData
        do {
            try PersistenceService.saveContext()
        } catch {
            print("Review wasn't saved")
        }
        //  send information about book to the BookVC
        protocolDelegate?.sendTheBook(book: book, newReviewIsExist: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: Delete action
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "Delete review?", message: "Are you sure you want to delete the current review?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            self.reviewTextView.text = nil
            self.book.review = nil
            //  saving the changes in CoreData
            do {
                try PersistenceService.saveContext()
            } catch {
                print("Review wasn't saved")
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //  MARK: Setup textView
    func setupTextView() {
        reviewTextView.delegate = self
        reviewTextView.text = book.review
        reviewTextView.addDoneButton(title: "Done", target: self, selector: #selector(dismissKeyboard(sender:)))
    }
    
    //  MARK: Dismiss keyboard function
    @objc func dismissKeyboard(sender: Any) {
        self.view.endEditing(true)
    }
}

