//
//  PostViewController.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile on 2024-04-04.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var generaField: UITextField!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var authorField: UITextField!
    @IBOutlet weak var ratingField: UITextField!
    @IBOutlet weak var isbnField: UITextField!
    weak var delegate: BookUpdateDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func postBookPressed(_ sender: UIButton) {
        guard let title = titleField.text,
              let author = authorField.text,
              let isbn = isbnField.text,
              let ratingText = ratingField.text,
              let rating = Double(ratingText),
              let genreString = generaField.text else {
            let alert = UIAlertController(title: "Error", message: "Please fill all Entry", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        //Spliting genre by "," if more than one.
        let genreArray = genreString.split(separator: ",").map { String($0.trimmingCharacters(in: .whitespaces)) }
        
        let newBook = Book(id: "", title: title, isbn: isbn, rating: rating, author: author, genre: genreArray)
        
        BookManager.addBook(book: newBook) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error posting new book-> \(error.localizedDescription)")
                } else {
                    self.dismiss(animated: true, completion: nil)
                    self.delegate?.didUpdateBook()
                }
            }
        }
    }
}
