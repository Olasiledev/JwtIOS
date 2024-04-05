//
//  UpdateBookViewController.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import UIKit

class UpdateBookViewController: UIViewController {

    @IBOutlet weak var bookISBN: UITextField!
    @IBOutlet weak var bookTitle: UITextField!
    @IBOutlet weak var bookAuthor: UITextField!
    @IBOutlet weak var bookRating: UITextField!
    weak var delegate: BookUpdateDelegate?
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateFIELDS()
    }
    
    
    //UPDATING VIEW
    func updateFIELDS() {
        guard let book = book else { return }
        bookISBN.text = book.isbn
        bookTitle.text = book.title
        bookAuthor.text = book.author
        bookRating.text = String(book.rating)
    }
    
    @IBAction func updateButtonPressed(_ sender: UIButton) {
        guard var book = book else {
            print("No book to update")
            return
        }
        
        if let title = bookTitle.text, let author = bookAuthor.text, let ratingText = bookRating.text,
           let rating = Double(ratingText) {
            book.title = title
            book.author = author
            book.rating = rating
        } else {
            let alert = UIAlertController(title: "Error", message: "Please fill all Entry", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let bookID = book.id else {
            print("No book ID")
            return
        }
        
        BookManager.updateBook(withId: bookID, updatedBook: book) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error updating book-> \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.didUpdateBook()
                }
            }
        }
    }
    
}
