//
//  AllergyViewController.swift
//  Dinecraft
//
//  Created by Tak Chung on 20/5/2022.
//

import UIKit

class AllergyViewController: UIViewController
{
    
    @IBOutlet var LblGrp: [UILabel]!
    @IBOutlet var SwitchGrp: [UISwitch]!
    @IBOutlet weak var NextBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        NextBtn.alpha = 0
        for Lbl in LblGrp {
            Lbl.center.x = -100
            Lbl.alpha = 0
        }
        for Switch in SwitchGrp {
            Switch.center.x = 69
            Switch.alpha = 0
        }
        for i in 0...13
        {
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.LblGrp[i].center.x = 123
                self.LblGrp[i].alpha = 1
            }), completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.SwitchGrp[i].center.x = 294
                self.SwitchGrp[i].alpha = 1
            }), completion: nil)
        }
        UIView.animate(withDuration: 1.0, delay: 1, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.NextBtn.alpha = 1}), completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDiet" {
            let VC = segue.destination as! DietViewController
            for Switch in SwitchGrp {
                VC.allergiesData.append(Switch.isOn)
            }
        }
    }
}
