//
//  BookListViewController.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import UIKit

class BookListViewController: UIViewController, UITableViewDelegate, BookUpdateDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        //Cell registration
        let nib = UINib(nibName: "BooksTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BooksCell")
        fetchBooks()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchBooks()
    }
    
    //Calling fetchbook function.
    func fetchBooks() {
        BookManager.fetchData { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedBooks):
                    self.books = fetchedBooks
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error fetching books ->\(error.localizedDescription)")
                }
            }
        }
    }
    //Protocol
    func didUpdateBook() {
        fetchBooks()
    }
    //Post bookVC Presentation
    @IBAction func presentPostViewCOntroller(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let postBookVC = storyboard.instantiateViewController(withIdentifier: "PostBookViewController") as? PostViewController else {
            return
        }
        postBookVC.delegate = self
        present(postBookVC, animated: true, completion: nil)
    }
    //Logout
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        let firstName = UserDefaults.standard.string(forKey: "firstName") ?? ""
          let lastName = UserDefaults.standard.string(forKey: "lastName") ?? ""
          let fullName = "\(firstName) \(lastName)"
          
          let alert = UIAlertController(title: "Logged Out Successfully", message: "Goodbye, \(fullName).", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
              if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") {
                  loginVC.modalPresentationStyle = .fullScreen
                  self.present(loginVC, animated: true, completion: {
                      UserDefaults.standard.removeObject(forKey: "firstName")
                      UserDefaults.standard.removeObject(forKey: "lastName")
                      UserDefaults.standard.removeObject(forKey: "userToken")
                  })
              }
          })
          self.present(alert, animated: true)
    }
    
}


// MARK: - UITableView
extension BookListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(books.count)
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BooksCell", for: indexPath) as! BooksTableViewCell
        let book = books[indexPath.row]
        cell.bookName?.text = book.title
        cell.author?.text = book.author
        cell.rating?.text = String(book.rating)
        return cell
    }
    
    //NAVIGATING TO UPDATE VC
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBook = books[indexPath.row]
        performSegue(withIdentifier: "BookDetailVC", sender: selectedBook)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BookDetailVC" {
            if let detailsVC = segue.destination as? UpdateBookViewController,
               let selectedBook = sender as? Book {
                detailsVC.book = selectedBook
                detailsVC.delegate = self
            }
        }
    }
    
    
    //MARK: - DELETE BOOK
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let bookToDelete = books[indexPath.row]
            
            BookManager.deleteBook(withId: bookToDelete.id ?? "") { error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Error deleting book -> \(error.localizedDescription)")
                    } else {
                        self.books.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            }
        }
    }
}
