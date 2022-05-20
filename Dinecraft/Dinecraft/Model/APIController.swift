//  APIController.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 18/5/2022,
//  using adapted code from http://bit.ly/3LsAhee
//
//  NOTE: most of the properties of the structs are commented out because we simply don't need them. If we need them in the future, just un-ccomment the lines and it *should* work
//
//  Classes:
//      APIController - handles requsting and parsing JSON from the API
//
//  Structs:
//      Response - top-level JSON response
//      Recipe - wrapper for the objects in the hits[] array
//      RecipeData - holder for all the recipe's data
//      Ingredient - custom type to hold the info about a recipe's ingredient
//      Measure - the units an Ingredient is measured in
//      Food - holder for the name of a food and its unique identifier
//
//  ========================================================================

import Foundation

//Structs for representing the JSON data received from the API
struct Response: Codable {
    let q: String
    //let from: Int
    //let to: Int
    //let more: Bool
    //let count: Int
    let hits: [Recipe]
}

struct Recipe: Codable {
    let recipe: RecipeData
}

struct RecipeData: Codable {
    //let uri: URL
    let label: String
    let image: URL //URL to download the source image
    let url: URL //URL to the original recipe's page - swiping right will open the recipe in Safari
    //let yield: Int
    //let calories: Float
    //let totalWeight: Float
    //let ingredients: [Ingredient] = []
    //let totalNutrients: NutrientInfo
    //let totalDaily: NutrientInfo
    //let dietLabels: [DietHealthLabel] = []
    //let healthLabels: [DietHealthLabel] = []
}

//struct Ingredient: Codable {
    //let foodID: String
    //let quantity: Float
    //let measure: Measure
    //let weight: Float
    //let food: Food
    //let foodCategory: String
//}

//struct Measure: Codable {
    //let uri: String
    //let label: String
//}

//struct Food: Codable {
    //let foodID: String
    //let label: String
//}


//Class
class APIController {
    //Properties
    let debugOn = true
    
    let entryURL = "https://api.edamam.com/search"
    let appID = "595649de"
    let appKey = "9d8f0ce9cfd505bf884f5f7c0d779387"
    
    //Variables
    var recipeBuffer: [RecipeData] = []
    
    
    //Methods
    func FillBuffer(){
        FillBuffer(keyword: Keywords.GetRandomKeyword())
    }
    
    func FillBuffer(keyword: String){
        let url = entryURL +  "?q=" + keyword + "&app_id=" + appID + "&app_key=" + appKey
        
        if debugOn {
            print("URL String: ", url)
        }

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
            if debugOn {
                print("q: ", decodedData.q)
                print("Label 1: ", decodedData.hits[0].recipe.label)
            }
            
            for i in 0..<decodedData.hits.count {
                recipeBuffer.append(decodedData.hits[i].recipe) //yes, I know you can append a whole array to another one, but this is neater for use in other places
            }
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
