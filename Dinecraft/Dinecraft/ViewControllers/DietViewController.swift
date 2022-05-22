//
//  DietViewController.swift
//  Dinecraft
//
//  Created by Tak Chung on 21/5/2022.
//

import UIKit

class DietViewController: UIViewController {
    @IBOutlet var LblGrp: [UILabel]!
    @IBOutlet var SwitchGrp: [UISwitch]!
    
    var allergiesData: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for Lbl in LblGrp {
            Lbl.center.x = -100
            Lbl.alpha = 0
        }
        
        for Switch in SwitchGrp {
            Switch.center.x = 120
            Switch.alpha = 0
        }
        
        for i in 0...5 {
            UIView.animate(withDuration: 1.0, delay: 0.1 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.LblGrp[i].center.x = 153
                self.LblGrp[i].alpha = 1
            }), completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.1 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.SwitchGrp[i].center.x = 320
                self.SwitchGrp[i].alpha = 1
            }), completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipe" {
            let VC = segue.destination as! RecipeViewController
            VC.allergiesData = self.allergiesData
            var parseArray: [Bool] = []
            for Switch in SwitchGrp {
                parseArray.append(Switch.isOn)
            }
            VC.dietsData = parseArray
        }
    }
}
