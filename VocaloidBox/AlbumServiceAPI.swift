//
//  AlbumServiceAPI.swift
//  VocaloidBox
//
//  Created by Corentin Dupont on 08/04/2019.
//  Copyright © 2019 Corentin Dupont. All rights reserved.
//

import Foundation

class AlbumServiceAPI {
    
    // MARK: Properties
    
    public static let shared = AlbumServiceAPI()
    private let urlSession = URLSession.shared
    private let baseURL = URL(string: "https://vocadb.net/api/albums")!
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()
    
    // Enum Endpoint
//    enum Endpoint: String, CustomStringConvertible, CaseIterable {
//
//        case nowPlaying = "now_playing"
//        case upcoming
//        case popular
//        case topRated = "top_rated"
//    }
    
    public enum APIServiceError: Error {
        case apiError
        case invalidEndpoint
        case invalidResponse
        case noData
        case decodeError
    }
    
    private func fetchResources<T: Decodable>(from start: Int, url: URL, completion: @escaping (Result<T, APIServiceError>) -> Void) {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        let startString = String(start)
        
        let queryItems = [
            URLQueryItem(name: "fields", value: "MainPicture, Tracks"),
            URLQueryItem(name: "start", value: startString)
        ]
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        
        print(url)
        
        urlSession.dataTask(with: url) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                
                    let values = try self.jsonDecoder.decode(T.self, from: data)
                    completion(.success(values))
                } catch let error {
                    print(error)
                    completion(.failure(.decodeError))
                }
            case .failure( _):
                completion(.failure(.apiError))
            }
            }.resume()
    }
    
    public func fetchAlbums(from start: Int, result: @escaping (Result<AlbumsResponse, APIServiceError>) -> Void) {
        let albumURL = baseURL
        fetchResources(from: start, url: albumURL, completion: result)
    }
    
    private init() {}
}
