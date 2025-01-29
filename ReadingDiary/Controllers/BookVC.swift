//
//  BookVC.swift
//  ReadingDiary
//
//  Created by Anna Panova on 17.10.19.
//  Copyright © 2019 Anna Panova. All rights reserved.
//

import UIKit
import SafariServices
import CoreData

class BookVC: UIViewController, UITextViewDelegate, BookSendingDelegateProtocol {
    
    @IBOutlet weak var bookCoverImage: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var starsFromGoodreadsLabel: UILabel!
    @IBOutlet weak var myStarsLabel: UILabel!
    @IBOutlet weak var myStarsTextField: UITextField!
    @IBOutlet weak var openBookOnGoodreadsButton: UIButton!
    @IBOutlet weak var startOfReadingTextField: UITextField!
    @IBOutlet weak var endOfReadingTextField: UITextField!
    @IBOutlet weak var addReviewButton: UIButton!
    @IBOutlet weak var editReviewButton: UIButton!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addToListOfBooksButton: UIBarButtonItem!
    
    let datePicker = UIDatePicker()
    //    Repository for storage statistics
    let repository = StatisticsRepository()
    
    //  book from SearchBookVC
    var book: FoundBook?
    //  book from CoreData storage
    var bookMO: Book?
    
    var linkString = String()
    var startOfReadingDate: Date?
    var endOfReadingDate: Date?
    
    //  parameter for checking existing new review
    var newReviewIsExist = false
    
    var addTitleAndAuthor = false
    
    //  book for send to the ReviewVC
    var bookforReviewVC: Book?
    
    //    delegate method for BookSendingDelegateProtocol
    func sendTheBook(book: Book, newReviewIsExist: Bool) {
        self.bookMO = book
        self.newReviewIsExist = newReviewIsExist
        self.checkReview(oldReview: bookMO!.review)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAddingTitleAndAuthor(add: addTitleAndAuthor)
        
        setupBookParameters()
        
        reviewTextView.delegate = self
        
        myStarsTextField.isEnabled = false
        startOfReadingTextField.isEnabled = false
        endOfReadingTextField.isEnabled = false
        addReviewButton.isEnabled = false
        editReviewButton.isEnabled = false
        addReviewButton.setTitleColor(.gray, for: .disabled)
        editReviewButton.setTitleColor(.gray, for: .disabled)
        
        setupDatePicker(textField: startOfReadingTextField)
        setupDatePicker(textField: endOfReadingTextField)
        setupTextFieldDelegate()
        setupGestRecognizer()
    }
    
    // MARK: Checking and setup fields for book
    func setupBookParameters() {
        if let book = book {
            //  setup for books found on Goodreads(from SearchBookVC)
            //  setup coverImage
            bookCoverImage.image = book.coverImage
            titleTextField.text = book.title
            authorTextField.text = book.author
            
            checkLinkAndStars(link: book.link, starsFromGoodreads: book.starsGoodreads)
            checkMyStars(myStars: nil)
            checkReview(oldReview: nil)
        } else if let bookMO = bookMO {
            //  setup for books frome CoreData Storage
            //  setup coverImage
            if let coverImage = bookMO.coverImage {
                self.bookCoverImage.image = UIImage(data: coverImage)
            }
            if let urlImage = bookMO.urlImage {
                let url = URL(string: urlImage)
                if let dataFromUrl = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        self.bookCoverImage.image = UIImage(data: dataFromUrl)
                    }
                }
            } else {
                bookCoverImage.image = UIImage(named: "simpleBookCover")
            }
            
            titleTextField.text = bookMO.title
            authorTextField.text = bookMO.author
            
            checkLinkAndStars(link: bookMO.link, starsFromGoodreads: bookMO.starsGoodreads)
            checkMyStars(myStars: bookMO.myStars)
            checkReview(oldReview: bookMO.review)
            
            if bookMO.startOfReading != nil {
                startOfReadingTextField.text = self.dateFormatterFromDateToString(date: bookMO.startOfReading!)
                startOfReadingDate = bookMO.startOfReading!
            }
            if bookMO.endOfReading != nil {
                endOfReadingTextField.text = self.dateFormatterFromDateToString(date: bookMO.endOfReading!)
                endOfReadingDate = bookMO.endOfReading!
            }
        } else {
            //  setup for new books that will be add manually
            checkLinkAndStars(link: nil, starsFromGoodreads: nil)
            checkMyStars(myStars: nil)
            checkReview(oldReview: nil)
        }
    }
    
    //    MARK: Schow book on Goodreads (open URL-link) action
    @IBAction func openBookOnGoodreadsAction(_ sender: UIButton) {
        //    check the URL:
        if  let url = URL(string: linkString) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Is there something wrong...", message: "Sorry, this link is invalid", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    //    MARK: Add review action
    @IBAction func addReviewAction(_ sender: UIButton) {
        openReviewVC()
    }
    
    //    MARK: Edit review action
    @IBAction func editReviewAction(_ sender: UIButton) {
        openReviewVC()
    }
    
    //  MARK: Go to the ReviewVC function
    func openReviewVC() {
        if saveNewBook() {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let reviewVC = storyboard.instantiateViewController(identifier: "reviewVC") as! ReviewVC
            reviewVC.book = bookforReviewVC!
            reviewVC.protocolDelegate = self
            self.navigationController?.pushViewController(reviewVC, animated: true)
        }
    }
    
    //    MARK: Edit/Add something to the Book description
    @IBAction func editAction(_ sender: UIBarButtonItem) {
        startOfReadingTextField.isEnabled = true
        endOfReadingTextField.isEnabled = true
        myStarsTextField.isEnabled = true
        
        //  checking is review exist?
        if reviewTextView.text != "Here can be your review" {
            //  we have some review
            editReviewButton.isEnabled = true
        } else {
            //    we don't have a review
            addReviewButton.isEnabled = true
        }
    }
    
    
    //  MARK: Checking link on Googreads and stars from Goodreads
    func checkLinkAndStars(link: String?, starsFromGoodreads: String?) {
        if link != nil {
            openBookOnGoodreadsButton.isEnabled = true
            self.linkString = link!
            starsFromGoodreadsLabel.text = "Goodreads's stars: " + starsFromGoodreads!
        } else {
            openBookOnGoodreadsButton.isEnabled = false
            openBookOnGoodreadsButton.setTitle("Link  to Goodreads is absent", for: .disabled)
            openBookOnGoodreadsButton.setTitleColor(.gray, for: .disabled)
            starsFromGoodreadsLabel.text = "Goodreads's stars are absent"
        }
    }
    
    //  MARK: Checking myStars
    func checkMyStars(myStars: String?) {
        if myStars != nil {
            self.myStarsTextField.text = myStars!
        } else {
            self.myStarsTextField.text = nil
        }
    }
    
    //  MARK: Checking review
    func checkReview(oldReview: String?) {
        //  in case we added new review or edit/delete old review
        if newReviewIsExist {
            if self.bookMO?.review != nil {
                self.reviewTextView.text = self.bookMO?.review!
            } else {
                self.reviewTextView.text = "Here can be your review"
            }
            //  in case we didn't add new review or edit/delete old review
        } else {
            //  check: is old review exist?
            if oldReview != nil {
                self.reviewTextView.text = oldReview
            } else {
                self.reviewTextView.text = "Here can be your review"
            }
        }
    }
    
    //  MARK: Check enabling title and author
    func checkAddingTitleAndAuthor(add: Bool) {
        titleTextField.isEnabled = add
        authorTextField.isEnabled = add
    }
    
    //  MARK: Setup datePicker for start/end reading
    func setupDatePicker(textField: UITextField) {
        textField.inputView = datePicker
        datePicker.addTarget(self, action: #selector(addDateFunction), for: .valueChanged)
        datePicker.datePickerMode = .date
        
        //  setup toolbar with done button
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(closeDatePickerFunction))
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        textField.inputAccessoryView = toolBar
    }
    
    //  MARK: Add date function
    @objc func addDateFunction() {
        //   take date from DatePicker and formate to string
        let dateFromPicker = dateFormatterFromDateToString(date: datePicker.date)
        
        //  in case we want to edit/add start
        if startOfReadingTextField.isEditing {
            //  put start date in textField
            startOfReadingTextField.text = dateFromPicker
            // in case end is exist
            if endOfReadingTextField.text != "" && endOfReadingTextField.text != nil {
                let endStr = endOfReadingTextField.text!
                //  check the start is earlier or equal the end
                if self.checkingDates(start: dateFormatterFromStringToDate(string: dateFromPicker), end: dateFormatterFromStringToDate(string: endStr)) {
                    //  save the start to the temporary property
                    startOfReadingDate = datePicker.date
                } else {
                    //  in case the start is later the end
                    startOfReadingTextField.text = nil
                    setupAlertController(title: "Is there something wrong...", message: "The end of reading date must be later or equal start date")
                }
                //  in case end is NOT exist
            } else {
                //  save the start to the temporary property
                startOfReadingDate = datePicker.date
            }
            //  in case we want to edit/add end
        } else if endOfReadingTextField.isEditing {
            //  put the end date in textField
            endOfReadingTextField.text = dateFromPicker
            // in case the start is exist
            if startOfReadingTextField.text != "" && startOfReadingTextField.text != nil  {
                let startStr = startOfReadingTextField.text!
                //  check the start is earlier or equal the end
                if self.checkingDates(start: dateFormatterFromStringToDate(string: startStr), end: dateFormatterFromStringToDate(string: dateFromPicker)) {
                    //  save the end to the temporary property
                    endOfReadingDate = datePicker.date
                } else {
                    //  in case the start is later the end
                    endOfReadingTextField.text = nil
                    setupAlertController(title: "Is there something wrong...", message: "The end of reading date must be later or equal start date")
                }
                //  in case the start is NOT exist
            } else {
                endOfReadingTextField.text = nil
                setupAlertController(title: "Is there something wrong...", message: "Please, enter the start of reading date")
            }
        }
    }
    
    //    MARK: checkin dates
    func checkingDates(start: Date, end: Date) -> Bool {
        if start <= end {
            return true
        } else {
            return false
        }
    }
    
    // Close datePicker function
    @objc func closeDatePickerFunction() {
        self.view.endEditing(true)
    }
    
    //  DateFormatter function from date to string
    func dateFormatterFromDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }
    
    //  DateFormatter function from string to date
    func dateFormatterFromStringToDate(string: String!) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        let date = dateFormatter.date(from: string)
        return date!
    }
    
    //  MARK: Save Book and open List of Books action
    @IBAction func saveChangingAction(_ sender: UIBarButtonItem) {
        if saveNewBook() {
            setupAlertControllerForSaving()
        }
    }
    
    // MARK: Save a new book function
    func saveNewBook() -> Bool {
        // check author and title - required parameters for book
        if titleTextField.text != "" && authorTextField.text != "" {
            let newBook = Book(context: PersistenceService.context)
            print("\(String(describing: titleTextField.text)), \(String(describing: authorTextField.text))")
            newBook.title = titleTextField.text!
            newBook.author = authorTextField.text!
            
            if startOfReadingTextField.text != nil {
                newBook.startOfReading = startOfReadingDate
            }
            
            if endOfReadingTextField.text != nil {
                newBook.endOfReading = endOfReadingDate
            }
            
            if myStarsTextField.text != "" {
                newBook.myStars = myStarsTextField.text
            } else {
                newBook.myStars = nil
            }
            
            //  checking is information from Goodreads exist?
            if starsFromGoodreadsLabel.text != "Goodreads's stars are absent" {
                if book != nil {
                    newBook.starsGoodreads = book!.starsGoodreads
                    newBook.id = book!.id
                    newBook.urlImage = String(describing: book!.urlImage)
                    newBook.coverImage = book?.coverImage?.pngData()
                } else if bookMO != nil {
                    newBook.starsGoodreads = bookMO!.starsGoodreads
                    newBook.id = bookMO!.id
                    newBook.urlImage = bookMO!.urlImage
                    newBook.coverImage = bookMO?.coverImage
                }
            }
            
            if reviewTextView.text != "Here can be your review" {
                newBook.review = reviewTextView.text!
            }
            
            //  save book to the CoreData storage
            do {
                print("TRY TO SAVE")
                try PersistenceService.saveContext()
                self.bookforReviewVC = newBook
                self.updateStatistics(start: newBook.startOfReading, end: newBook.endOfReading, title: newBook.title!, author: newBook.author!)
                return true
            } catch {
                print("Book wasn't saved")
                return false
            }
        } else {
            print("title and author aren't exist- show alert controller")
            // title and author aren't exist- show alert controller
            setupAlertController(title: "Is there something wrong...", message: "Please, enter the book's title and author")
            return false
        }
    }
    
    //  MARK: setup alert controller for empty title or author fields
    func setupAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    //    MARK: setup alert controller for saving book
    func setupAlertControllerForSaving() {
        let alertController = UIAlertController(title: "Book was saved", message: "Do you want open the list on books?", preferredStyle: .alert)
        let openAction = UIAlertAction(title: "Open ", style: .default) { (action) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(openAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //  Calculate reading dutation and save statistics to the NSUserDefaults storage
    func updateStatistics(start: Date?, end: Date?, title: String, author: String) {
        if let start = start,  let end = end {
            let numberOfSecondsInDay = 86400.0
            let duration = 1 + end.timeIntervalSince(start)/numberOfSecondsInDay
            
            //  setup book identificator
            let id = title + author
            
            //  save results to the storage
            repository.addNewBook(id: id, duration: duration)
            repository.save()
        }
    }
}







