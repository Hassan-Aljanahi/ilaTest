//
//  DataGetter.swift
//  testIntUIKIT
//
//  Created by Hassan Aljanahi on 08/10/2023.
//

import Foundation
import UIKit

struct ExampleImages {
    
    
    func getData(completion: @escaping([example]) -> ()) {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")!
        URLSession.shared.fetchData(for: url) { (result: Result<[example], Error>) in
            switch result {
            case .success(let examples):
                completion(Array(examples[0..<500]))
            case .failure(_): break
              
            }
        }.resume()
    }
}

extension UIImageView {
    
    func getImage(url: String) ->  URLSessionDataTask {
        
        let url = URL(string: url)!
        return URLSession.shared.fetchImage(for: url) { (result: Result<Data, Error>) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.image = UIImage(data: image)
                }
            case .failure(_): break
              
            }
        }
    }
}

extension URLSession {
    func fetchData<T: Decodable>(for url: URL, completion: @escaping (Result<T, Error>) -> Void) ->  URLSessionDataTask {
        return self.dataTask(with: url) { (data, response, error) in
          if let error = error {
            completion(.failure(error))
          }

          if let data = data {
            do {
              let object = try JSONDecoder().decode(T.self, from: data)
              completion(.success(object))
            } catch let decoderError {
              completion(.failure(decoderError))
            }
          }
        }
    }
    
    func fetchImage(for url: URL, completion: @escaping (Result<Data, Error>) -> Void) ->  URLSessionDataTask {
        return self.dataTask(with: url) { (data, response, error) in
          if let error = error {
            completion(.failure(error))
          }

          if let data = data {
            do {
              completion(.success(data))
            } catch let decoderError {
              completion(.failure(decoderError))
            }
          }
        }
    }
    
}
