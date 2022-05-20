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
//      Ingredient
//      Measure
//      Food

import Foundation

//Structs for representing the JSON data received from the API
struct Response: Codable {
    
    
    
    
    
    let q: String
//    var from: Int
//    var to: Int
//    var more: Bool
//    var count: Int
    let hits: [Recipe]
}

struct Recipe: Codable {
    
    let recipe: RecipeData
}

struct RecipeData: Codable {
    //let uri: URL
    let label: String
//    var image: URL //URL to download the source image
//    var url: URL //URL to the original recipe's page - swiping right will open the recipe in Safari
//    var yield: Int
//    var calories: Float
//    var totalWeight: Float
//    var ingredients: [Ingredient] = []
    //var totalNutrients: NutrientInfo
    //var totalDaily: NutrientInfo
    //var dietLabels: [DietHealthLabel] = []
    //var healthLabels: [DietHealthLabel] = []
}
//struct Ingredient: Codable {
//    let foodID: String
//    let quantity: Float
//    let measure: Measure
//    let weight: Float
//    let food: Food
//    let foodCategory: String
//}
//
//struct Measure: Codable {
//    let uri: String
//    let label: String
//}
//
//struct Food: Codable {
//    let foodID: String
//    let label: String
//}


//Class
class APIController {
    //Properties
    let entryURL = "https://api.edamam.com/search"
    let appID = "595649de"
    let appKey = "9d8f0ce9cfd505bf884f5f7c0d779387"
    
    //Variables
    var recipeBuffer: [Response] = []
    
    
    //Methods
    func FillBuffer(){
        FillBuffer(keyword: Keywords.GetRandomKeyword())
    }
    
    func FillBuffer(keyword: String){
        let url = entryURL +  "?q=" + keyword + "&app_id=" + appID + "&app_key=" + appKey
        print(url)

        self.LoadJson(fromURLString: url) { (result) in
            switch result {
            case .success(let data):
                self.Parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //Functions
    func Parse(jsonData: Data) {
        do {
            let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
            print("q: ", decodedData.q)
            print("Label 1: ", decodedData.hits[0].recipe.label)
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
