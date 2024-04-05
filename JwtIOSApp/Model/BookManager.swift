//
//  BookManager.swift
//  JwtIOSApp
//
//  Created by Oladipupo Olasile & Ripudaman Singh on 2024-04-04.
//

import Foundation
//Protocol when book is updated
protocol BookUpdateDelegate: AnyObject {
    func didUpdateBook()
}
//Struct for a Book model
struct Book: Codable {
    let id: String?
    var title: String
    var isbn: String
    var rating: Double
    var author: String
    var genre: [String]
    //Coding keys
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case title
        case isbn = "ISBN"
        case rating
        case author
        case genre
    }
}


//Struct for CRUD operations
struct BookManager {
    //Generating authorization header with token from userDefaults
    static func authorizationHeader() -> [String: String]? {
          if let token = UserDefaults.standard.string(forKey: "userToken") {
              return ["Authorization": "Bearer \(token)"]
          } else {
              print("Token not found")
              return nil
          }
      }

      //MARK: - FETCH ALL BOOKS
      static func fetchData(completion: @escaping (Result<[Book], Error>) -> Void) {
          guard let url = URL(string: "https://jwtassingment.onrender.com/api/books/"),
                let headers = authorizationHeader() else {
              print("Invalid URL or Token")
              return
          }
          //URL request
          var request = URLRequest(url: url)
          request.allHTTPHeaderFields = headers

          URLSession.shared.dataTask(with: request) { data, response, error in
              guard let data = data else {
                  if let error = error {
                      completion(.failure(error))
                  } else {
                      completion(.failure(NSError(domain: "Data Error", code: 0, userInfo: nil)))
                  }
                  return
              }
              do {
                  //Decoding JSON data
                  let decoder = JSONDecoder()
                  let books = try decoder.decode([Book].self, from: data)
                  completion(.success(books))
              } catch {
                  completion(.failure(error))
              }
          }.resume()
      }

    // MARK: - POST
    static func addBook(book: Book, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jwtassingment.onrender.com/api/books/"),
              let headers = authorizationHeader() else {
            print("Invalid URL or Token")
            return
        }
        // URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // Request headers
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            // Encoding to JSON
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(book)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }.resume()
        } catch {
            completion(error)
        }
    }


    // MARK: - Update Book
    static func updateBook(withId id: String, updatedBook: Book, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jwtassingment.onrender.com/api/books/\(id)"),
              let headers = authorizationHeader() else {
            print("Invalid URL or Token")
            return
        }
        //URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.allHTTPHeaderFields = headers
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            //Encoding Data
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(updatedBook)
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { _, response, error in
                if let error = error {
                    completion(error)
                    return
                }
                completion(nil)
            }.resume()
        } catch {
            completion(error)
        }
    }


    // MARK: - Delete Book
    static func deleteBook(withId id: String, completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "https://jwtassingment.onrender.com/api/books/\(id)"),
              let headers = authorizationHeader() else {
            print("Invalid URL or Token")
            return
        }
        //URL Request
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

  }

