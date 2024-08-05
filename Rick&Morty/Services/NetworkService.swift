//
//  NetworkService.swift
//  Rick&Morty
//

import Foundation
import Combine


protocol NetworkServiceProtocol {
    var constructor: URLConstructor { get }
    var decoder: JSONDecoder { get }
    func fetchEpisodes(completion: @escaping (Result<Episodes, Error>) -> Void) // last_ep_id: String?
    func requestCharacter(id: String, completion: @escaping (Result<Character, Error>) -> Void)
}

struct NetworkService: NetworkServiceProtocol {
    internal var constructor: URLConstructor = URLConstructor()
    internal var decoder: JSONDecoder = JSONDecoder()
    
    func fetchEpisodes(completion: @escaping (Result<Episodes, Error>) -> Void) {
        guard let url = constructor.constructURL(for: .episodes) else { return }
        
        self.request(with: url, ofType: Episodes.self) { result in
            completion(result)
        }
    }
    
    func requestCharacter(id: String, completion: @escaping (Result<Character, Error>) -> Void) {
        print(id)
        guard let url = URL(string: id) else { return }
        
        self.request(with: url, ofType: Character.self) { result in
            completion(result)
        }
    }
    
    private func request<T: Decodable>(with url: URL, ofType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request, completionHandler: { data, _, error in
            guard let data, error == nil else {
                if let error { completion(.failure(error)) }
                return
            }
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
//            }
//            catch let error {
//                completion(.failure(error))
//            }
            } catch DecodingError.dataCorrupted(let context) {
               print(context.debugDescription)
           } catch DecodingError.keyNotFound(let key, let context) {
               print("\(key.stringValue) was not found, \(context.debugDescription)")
           } catch DecodingError.typeMismatch(let type, let context) {
               print("\(type) was expected, \(context.debugDescription)")
           } catch DecodingError.valueNotFound(let type, let context) {
               print("no value was found for \(type), \(context.debugDescription)")
           } catch {
               print("I know not this error")
           }
        }).resume()
    }
}
