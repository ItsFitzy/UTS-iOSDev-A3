//
//  RecipeViewController.swift
//  Dinecraft
//
//  Created by Christa Zhang on 21/5/2022.
//  using code adapted from http://bit.ly/3lwBdDP
//
//  Extended by Ethan Fitzgerald on 22/5/2022
//
//  Classes:
//      RecipeViewController - ViewController for the Recipe Scene
//
//  ========================================================================

import UIKit

class RecipeViewController: UIViewController {
    //Properties
    let debugOn = true //toggles on/off some general debug messages
    let deltaTime: Float = 0.2 //time in seconds between the update method being called
    var initialLoadingTime: Float = 2 //time given from the moment the scene loads to when the first recipe is displayed
    
    
    //Variables
    var allergiesData: [Bool] = [] //passed from the Allergies screen, stores the User's allergy selections
    var dietsData: [Bool] = [] //passed from the Diets screen, stores the User's diet selections
    
    var currentRecipeURL: URL? //used to store the currentRecipe's URL (easier to make this optional than another variable)
    
    var initialRecipeShown = false //flag for if the first recipe's been shown or not
    var buffering = false //flag for if recipes are currently being loaded 
    
    var timeSinceLoad: Float = 0 //keeps track of how much time has passed since recipes were loaded, used to recover if we have a combination that produces 0 results
    
    var bufferCountLastUpdate = 0
    var initialLoadQuota = -1
    
    
    //References
        //UI References
    @IBOutlet weak var recipeImage: UIImageView!

    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeYield: UILabel!
    @IBOutlet weak var recipeCalories: UILabel!
    
        //Object references
    let apiController = APIController()
    
    
    //Methods
        //Engine-called
    override func viewDidLoad() { //Called when the scene loads
        super.viewDidLoad()

        apiController.viewController = self
        LoadRecipes()
        
        var _ = Timer.scheduledTimer(timeInterval: Double(deltaTime), target: self, selector: #selector(RecipeViewController.Update), userInfo: nil, repeats: true)
    }
    
        //UI-called
    @IBAction func OnNextButton(_ sender: Any) { //Called when the 'Ew! Next!' button is tapped
        ShowNextRecipe()
    }
    
    @IBAction func OnMoreButton(_ sender: Any) { //Called when the 'Tell me more!' button is tapped
        UIApplication.shared.open(currentRecipeURL!) //open the current recipe's URL in Safari
    }
    
        //Update methods (called every deltaTime seconds)
    @objc func Update(){ //Called by the timer in viewDidLoad() every deltaTime seconds
        timeSinceLoad += deltaTime
        initialLoadingTime -= deltaTime
        
        CheckForFirstLoad()
        CheckBufferCount()
    }
    
    func CheckForFirstLoad(){ //Checks for when the first recipe's prerequisites have loaded, then calls the relevant functions
        if initialRecipeShown { return }

        if apiController.images.count >= 1 {
            OnFirstRecipe()
            ShowNextRecipe()
            initialRecipeShown = true
        }
    }
    
    func CheckBufferCount(){ //By checking the length of the recipeBuffer every 'frame', check if our current search combination gave us 0 results and load more
        if apiController.recipeBuffer.count == bufferCountLastUpdate {
            if timeSinceLoad >= 5 && initialRecipeShown == false && apiController.recipeBuffer.count == 0 { //if we've picked a combination that doesn't give any results,
                buffering = false
                LoadRecipes()
            }
        }
        bufferCountLastUpdate = apiController.recipeBuffer.count
    }
    
        //Misc.
    func LoadRecipes(){ //Handles the calls to fill the recipe buffer
        if buffering == false {
            apiController.FillBuffer(allergies: GetAllergiesArray(), diets: GetDietsArray())
            buffering = true
            timeSinceLoad = 0
        }
    }
    
    func OnFirstRecipe() { //Called when the first recipe is fully loaded (Recipe info + image)
        if debugOn { print("RecipeViewController.OnFirstRecipe(): Hello!") }
        
        self.navigationItem.title = ""
    }
    
    func ShowNextRecipe() { //Update the UI with the latest recipe, then load more
        if apiController.recipeBuffer.count > 0 && apiController.images.count > 0 {
            let currentRecipe = apiController.recipeBuffer.removeFirst()
            currentRecipeURL = currentRecipe.url
            recipeImage.image = apiController.PopImage(url: currentRecipe.image)
            recipeTitle.text = currentRecipe.label
            recipeYield.text = String(currentRecipe.yield) + " servings"
            recipeCalories.text = String(currentRecipe.calories) + "kJ"
        }
        
        if apiController.recipeBuffer.count < apiController.recipeBufferThreshold {
            buffering = false
            LoadRecipes()
        }
    }
    
    
    //Functions
    func GetAllergiesArray() -> [String] { //Converts the Allergies switches from a bool-array to a String array that can be used in the API URLs
        var output: [String] = []
        for i in 0..<allergiesData.count {
            if allergiesData[i] == true {
                output.append(apiController.allergiesLibrary[i])
            }
        }
        return output
    }
    
    func GetDietsArray() -> [String] { //Converts the Diets switches from a bool-array to a String array that can be used in the API URLs
        var output: [String] = []
        for i in 0..<dietsData.count {
            if dietsData[i] == true {
                output.append(apiController.dietsLibrary[i])
            }
        }
        return output
    }
}
