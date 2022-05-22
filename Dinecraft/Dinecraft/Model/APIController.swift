//  APIController.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 18/5/2022,
//  using adapted code from http://bit.ly/3LsAhee
//
//  Extended by Christa Zhang on 21/5/2022,
//  using code adapted from http://bit.ly/385XBAV
//
//  Implementing the Edamam API, using the documention from https://developer.edamam.com/edamam-docs-recipe-api-v1
//
//  NOTE: most of the properties of the structs are commented out because we simply don't need them. If we need them in the future, just un-ccomment the lines and it *should* work
//
//  Classes:
//      APIController - handles requsting and parsing JSON from the API
//
//  Structs:
//      Response - top-level JSON response
//      [Unused] Recipe - wrapper for the objects in the hits[] array
//      [Unused] RecipeData - holder for all the recipe's data
//      [Unused] Ingredient - custom type to hold the info about a recipe's ingredient
//      [Unused] Measure - the units an Ingredient is measured in
//      [Unused] Food - holder for the name of a food and its unique identifier
//      ImageURLPair - struct for pairing downloaded UIImages with their URLs (a dictionary didn't work very well)
//
//  ========================================================================

import Foundation
import UIKit

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
    let yield: Int
    let calories: Float
    //let totalWeight: Float
    //let ingredients: [Ingredient] = []
    //let totalNutrients: NutrientInfo
    //let totalDaily: NutrientInfo
    //let dietLabels: [DietLabel] = []
    //let healthLabels: [HealthLabel] = []
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

struct ImageURLPair {
    let image: UIImage
    let url: URL
}


//Class
class APIController {
    //Properties
    let debugOn = true //toggles on/off some general debug messages
    
    let recipeBufferThreshold = 4 //minimum length of the recipe buffer before more recipes are added
    
    let entryURL = "https://api.edamam.com/search" //entry-point for the Edamam API
    let appID = "595649de" //appID required for the API
    let appKey = "9d8f0ce9cfd505bf884f5f7c0d779387" //appKey required for the API
    
    
    //Variables
    var recipeBuffer: [RecipeData] = [] //queue-like data structure for storing the displayed recipes
    var images: [ImageURLPair] = [] //dictionary-like data structure for storing the recipes' images associated with their URLs (to identify them)
    
    
    //References
    var viewController: RecipeViewController? //reference to the Recipe ViewController
    
    
    //Data
    let allergiesLibrary = [ //All the allergy search options supported by Edamam
        "alcohol-free", //Free alcohol? ;)
        "immuno-supportive",
        "celery-free",
        "crustacean-free",
        "dairy-free",
        "egg-free",
        "fish-free",
        "fodmap-free",
        "gluten-free",
        "keto-friendly",
        "kidney-friendly",
        "kosher",
        "low-potassium",
        "lupine-free",
        "mustard-free",
        "low-fat-abs",
        "no-oil-added",
        "low-sugar",
        "paleo",
        "peanut-free",
        "pescatarian",
        "pork-free",
        "red-meat-free",
        "sesame-free",
        "shellfish-free",
        "soy-free",
        "sugar-conscious",
        "tree-nut-free",
        "vegan",
        "vegetarian",
        "wheat-free"
    ]
    
    let dietsLibrary = [ //All the diet search options supported by Edamam
        "balanced",
        "high-fibre",
        "high-protein",
        "low-carb",
        "low-fat",
        "low-sodium"
    ]
    
    
    //Methods
        //FillBuffer() overflow methods
    func FillBuffer(){
        FillBuffer(keyword: Keywords.GetRandomKeyword())
    }
    
    func FillBuffer(keyword: String){
        FillBuffer(keyword: keyword, allergies: [], diets: [])
    }
    
    func FillBuffer(allergies: [String], diets: [String]){
        FillBuffer(keyword: Keywords.GetRandomKeyword(), allergies: allergies, diets: diets)     
    }
    
    func FillBuffer(keyword: String, allergies: [String], diets: [String]){ //Constructs the API URL based on the given parameters, then pass the returned JSON into Parse()
        var url = entryURL +  "?q=" + keyword + "&app_id=" + appID + "&app_key=" + appKey
        
        for i in 0..<allergies.count { //for each of the allergies passed in
            if allergiesLibrary.contains(allergies[i]) { //if the input allergy is valid...
                url += "&health=" + allergies[i] //...add it as a query parameter
            }
        }
        
        for i in 0..<diets.count { //deja-vu for the diets parameter
            if dietsLibrary.contains(diets[i]) {
                url += "&diet=" + diets[i]
            }
        }
        
        if debugOn { print("URL String: ", url) }

        self.LoadJson(fromURLString: url) { (result) in
            switch result {
            case .success(let data):
                self.Parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
        //Misc.
    func PushToImages(image: UIImage, url: URL){ //Makes an ImageURLPair from the given parameters and appends it to the images array/dictionary thing
        images.append(ImageURLPair(image: image, url: url))
    }
    
    
    //Functions
        //API/API Helpers
    func Parse(jsonData: Data) { //Attempts to parse the given JSON into a Response struct. If it does, pushes the first few to the recipeBuffer and starts their images downloading
        do {
            let decodedData = try JSONDecoder().decode(Response.self, from: jsonData)
            
            for i in 0..<min(decodedData.hits.count, recipeBufferThreshold) {
                recipeBuffer.append(decodedData.hits[i].recipe) //yes, I know you can append a whole array to another one, but this is neater for use in other places
            }
            
            let imageURLs = GetImageURLs()
            for i in 0..<imageURLs.count {
                DownloadImage(from: imageURLs[i])
            }
        } catch {
            print("APIController.Parse(): JSON decode error!")
        }
    }
    
    func LoadJson(fromURLString urlString: String, completion: @escaping (Result<Data, Error>) -> Void) { //Imma be real idk how this works I copied this, pretty sure it uses Swift's built-in URLSession system, stores the returned data and then passes back the result and data
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
    
    func DownloadImage(from url: URL) { //Used in conjunction with GetImageData() to download images from the given URL, then push them to the images array
        if debugOn { print("Download Started: ", url) }
        
        GetImageData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            
            if self.debugOn { print("Download Finished: ", url) }
            
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.PushToImages(image: UIImage(data: data) ?? UIImage(named: "Cake.png")!, url: url)
            }
        }
    }
    
    func GetImageData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
        //Misc
    func GetImageURLs() -> [URL] { //Returns an array of all the image URLs in the recipeBuffer
        var output: [URL] = []
        for i in 0..<recipeBuffer.count {
            output.append(recipeBuffer[i].image)
        }
        return output
    }
    
    func PopImage(url: URL) -> UIImage { //Returns the image downloaded from the given URL
        for i in 0..<images.count {
            if images[i].url == url {
                return images.remove(at: i).image
            }
        }
        return UIImage(named: "Cake.png")! //default to the Cake image
    }
}
