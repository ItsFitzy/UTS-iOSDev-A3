//
//  RecipeViewController.swift
//  Dinecraft
//
//  Created by Christa Zhang on 21/5/2022.
//  using code adapted from http://bit.ly/3lwBdDP
//
//  Extended by Ethan Fitzgerald on 22/5/2022
//
//  ========================================================================

import UIKit

class RecipeViewController: UIViewController {
    //Properties
    let debugOn = true
    let deltaTime: Float = 0.2 //time in seconds between the update method being called
    
    
    //Variables
    var allergiesData: [Bool] = []
    var dietsData: [Bool] = []
    
    var initialRecipeShown = false
    var fillBufferQueued = true
    var buffering = false
    
    var timeSinceLoad: Float = 0
    
    var bufferCountLastUpdate = 0
    
    
    //References
        //UI References
    @IBOutlet weak var recipeImage: UIImageView!

    
        //Object references
    let apiController = APIController()
    
    
    //Methods
        //Engine-called
    override func viewDidLoad() {
        super.viewDidLoad()

        apiController.viewController = self
        LoadRecipes()
        
        var _ = Timer.scheduledTimer(timeInterval: Double(deltaTime), target: self, selector: #selector(RecipeViewController.Update), userInfo: nil, repeats: true)
    }
    
        //Update methods (called every deltaTime seconds)
    @objc func Update(){
        timeSinceLoad += deltaTime
        CheckForFirstLoad()
        CheckBufferThreshold()
        CheckBufferCount()
    }
    
    func CheckForFirstLoad(){
        if initialRecipeShown { return }

        if apiController.images.count >= 1 {
            OnFirstRecipe()
            ShowNextRecipe()
            initialRecipeShown = true
        }
    }
    
    func CheckBufferThreshold(){
        if apiController.images.count <= apiController.recipeBufferThreshold {
            LoadRecipes()
        }
    }
    
    func CheckBufferCount(){
        if apiController.images.count == bufferCountLastUpdate {
            if timeSinceLoad >= 5 && initialRecipeShown == false { //if we've picked a combination that doesn't give any results,
                buffering = false
                LoadRecipes()
            }
        } else if apiController.images.count > bufferCountLastUpdate {
            buffering = false //we know our buffering period is done when the length of the buffer increases
        } else {
            //if we need to do something when the recipe buffer has decreased in length
        }
        bufferCountLastUpdate = apiController.images.count
    }
    
        //Misc.
    func LoadRecipes(){
        if buffering == false {
            apiController.FillBuffer(allergies: GetAllergiesArray(), diets: GetDietsArray())
            buffering = true
            timeSinceLoad = 0
        }
    }
    
    func OnFirstRecipe() {
        if debugOn {
            print("RecipeViewController.OnFirstRecipe(): Hello!")
        }
        
        self.navigationItem.title = ""
    }
    
    func ShowNextRecipe() {
        recipeImage.image = apiController.images.removeFirst()
        let currentRecipe = apiController.recipeBuffer.removeFirst()
    }
    
    
    //Functions
    func GetAllergiesArray() -> [String] {
        var output: [String] = []
        for i in 0..<allergiesData.count {
            if allergiesData[i] == true {
                output.append(apiController.allergiesLibrary[i])
            }
        }
        return output
    }
    
    func GetDietsArray() -> [String] {
        var output: [String] = []
        for i in 0..<dietsData.count {
            if dietsData[i] == true {
                output.append(apiController.dietsLibrary[i])
            }
        }
        return output
    }
}
