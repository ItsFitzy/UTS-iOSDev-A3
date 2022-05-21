//
//  DietViewController.swift
//  Dinecraft
//
//  Created by Bennett Chung on 20/5/2022.
//

import UIKit

class AllergyViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var LblGrp: [UILabel]!
    @IBOutlet var SwitchGrp: [UISwitch]!
    var allergiesData: [Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1200)
        for Lbl in LblGrp {
            Lbl.center.x = -100
            Lbl.alpha = 0
        }
        for Switch in SwitchGrp {
            Switch.center.x = 120
            Switch.alpha = 0
        }
        for i in 0...30
        {
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.LblGrp[i].center.x = 153
                self.LblGrp[i].alpha = 1
            }), completion: nil)
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.SwitchGrp[i].center.x = 320
                self.SwitchGrp[i].alpha = 1
            }), completion: nil)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDiets" {
            let VC = segue.destination as! DietViewController
            var parseArray: [Bool] = []
            for Switch in SwitchGrp {
                parseArray.append(Switch.isOn)
            }
            VC.allergiesData = parseArray
        }
    }
}
