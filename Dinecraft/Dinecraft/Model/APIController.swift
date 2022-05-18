//
//  APIController.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 18/5/2022,
//  using code from http://bit.ly/3LsAhee
//
//  Classes:
//      APIController
//
//  Structs:
//      RecipeData

import Foundation

//Struct for representing the JSON data received from the API
struct RecipeData: Codable {
    let title: String
    let description: String
}

class APIController {
    //Variables
    var urlString = "https://api.edamam.com/search"
    let appID = "595649de"
    let appKey = "9d8f0ce9cfd505bf884f5f7c0d779387"
    
    
    //Functions
    func Parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(RecipeData.self, from: jsonData)
            print("Title: ", decodedData.title)
            print("Description: ", decodedData.description)
            print("===================================")
        } catch {
            print("APIController.Parse(): JSON decode error")
        }
    }
    
    func LoadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
}
