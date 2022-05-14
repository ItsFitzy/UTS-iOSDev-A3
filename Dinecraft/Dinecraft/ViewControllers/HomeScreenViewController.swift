//
//  ViewController.swift
//  Dinecraft
//
//  Created by Ethan Fitzgerald on 1/5/2022.
//

import UIKit

class HomeScreenViewController: UIViewController {

    @IBOutlet weak var StartBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.hidesBackButton = true
        StartBtn.titleLabel?.font = UIFont(name: "minecraft-font", size: 22)
    }


}

