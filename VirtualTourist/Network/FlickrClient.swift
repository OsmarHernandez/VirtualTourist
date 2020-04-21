//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Osmar Hernández on 18/04/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation

fileprivate enum Method: String {
    case photosSearch = "flickr.photos.search"
}

struct FlickrClient {
    
    private static let baseURL = "https://api.flickr.com/services/rest"
    private static let apiKey = "764861c8c9d14359f07a68f88b07f6f8"
    
    private static func addParams(_ params: [String : String], to queryItems: inout[URLQueryItem]) {
        for (key, value) in params {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
    }
    
    private static func flickrURL(_ method: Method, parameters: [String : String]?) -> URL {
        var components = URLComponents(string: baseURL)!
        
        var queryItems: [URLQueryItem] = []
        
        let baseParams = [
            "method" : method.rawValue,
            "format" : "json",
            "nojsoncallback": "1",
            "api_key" : apiKey
        ]
        
        addParams(baseParams, to: &queryItems)
        
        if let additionalParams = parameters {
            addParams(additionalParams, to: &queryItems)
        }
        
        components.queryItems = queryItems
        
        return components.url!
    }
    
    private static func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let responseObject = try decoder.decode(responseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    static func getPhotos(_ parameters: [String : String]?, completion: @escaping (PhotosResponse?, Error?) -> Void) {
        taskForGETRequest(url: flickrURL(.photosSearch, parameters: parameters), responseType: FlickrResponse.self) { (response, error) in
            completion(response?.photos, error)
        }
    }
    
    static func downloadImage(from path: String, completion: @escaping (Data?, Error?) -> Void) {
        let imageURL = URL(string: path)!
        
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        
        task.resume()
    }
}
