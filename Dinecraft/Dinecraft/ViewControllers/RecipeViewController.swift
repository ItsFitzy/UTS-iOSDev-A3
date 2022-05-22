//
//  RecipeViewController.swift
//  Dinecraft
//
//  Created by Christa Zhang on 21/5/2022.
//  using code adapted from http://bit.ly/3lwBdDP
//
//  ========================================================================

import UIKit

class RecipeViewController: UIViewController {
    //Properties
    let debugOn = true
    let deltaTime = 0.2 //time in seconds between the update method being called
    
    
    //Variables
    var allergiesData: [Bool] = []
    var dietsData: [Bool] = []
    
    var initialRecipeShown = false
    var fillBufferQueued = true
    
    
    //References
        //UI References
    @IBOutlet weak var recipeImage: UIImageView!

    
        //Object references
    let apiController = APIController()
    
    
    //Methods
        //Engine-called
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        apiController.viewController = self
        LoadRecipes()
        
        print("Allergies length: ", allergiesData.count)
        print("Diets length: ", dietsData.count)
        print("Allergies API length: ", apiController.allergiesLibrary.count)
        print("Diets API length: ", apiController.dietsLibrary.count)
        
        var _ = Timer.scheduledTimer(timeInterval: deltaTime, target: self, selector: #selector(RecipeViewController.LoadRecipes), userInfo: nil, repeats: true)
    }
    
    
        //Custom
    @objc func LoadRecipes(){
        if initialRecipeShown == false {
            if fillBufferQueued == true{
                apiController.FillBuffer() // this needs to be edited with the allergies and diets
                fillBufferQueued = false
            }
            
            if apiController.images.count >= 1 {
                OnFirstRecipe()
                ShowNextRecipe()
            }
        }
        
        if apiController.recipeBuffer.count > apiController.recipeBufferThreshold {
            return
        }
    }
    
    func OnFirstRecipe() {
        if debugOn {
            print("RecipeViewController.OnFirstRecipe(): Hello!")
        }
        
        self.navigationItem.title = ""
        initialRecipeShown = true
    }
    
    func ShowNextRecipe() {
        recipeImage.image = apiController.images.removeFirst()
        let currentRecipe = apiController.recipeBuffer.removeFirst()
    }
}
