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
    let recipeBufferMinimum = 5 //minimum length of the recipe buffer before more recipes are added
    
    
    //Variables
    var initialRecipeShown = false
    
    
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
        
        var _ = Timer.scheduledTimer(timeInterval: deltaTime, target: self, selector: #selector(RecipeViewController.LoadRecipes), userInfo: nil, repeats: true)
    }
    
    
        //Custom
    @objc func LoadRecipes(){
        if initialRecipeShown == false {
            if apiController.images.count >= 1 {
                OnFirstRecipe()
                ShowNextRecipe()
            }
        }
        
        if apiController.recipeBuffer.count > recipeBufferMinimum {
            return
        }
        
        apiController.FillBuffer() // this needs to be edited with the allergies and diets
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
