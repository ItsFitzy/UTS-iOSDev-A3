//
//  ViewController.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 1/5/2022.
//

import UIKit

class HomeScreenViewController: UIViewController {
    //Properties
    let debugOn = true

    //References
        //UI references
    @IBOutlet weak var TitleImg: UIImageView!
    @IBOutlet weak var StartBtn: UIButton!
    
        //Object references
    let apiController = APIController()
    
    
    //Methods
        //Engine-called
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        StartBtn.configuration?.attributedTitle?.font = UIFont(name: "MinecraftFont", size: 50)
        
        TitleImg.center.y = TitleImg.center.y + 150
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({
            self.TitleImg.center.y = 174
        }), completion: nil)
    }
}
