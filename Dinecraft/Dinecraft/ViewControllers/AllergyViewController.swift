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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for Lbl in LblGrp {
            Lbl.center.x = -100
            Lbl.alpha = 0
        }
        for i in 0...13
        {
            UIView.animate(withDuration: 1.0, delay: 0.1 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.LblGrp[i].center.x = 123
                self.LblGrp[i].alpha = 1
            }), completion: nil)
        }
    }
}
