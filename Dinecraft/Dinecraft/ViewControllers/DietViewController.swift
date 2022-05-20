//
//  DietViewController.swift
//  Dinecraft
//
//  Created by Bennett Chung on 20/5/2022.
//

import UIKit

class DietViewController: UIViewController
{
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var LblGrp: [UILabel]!
    var allergiesData: [Bool] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1200)
        for Lbl in LblGrp {
            Lbl.center.x = -100
            Lbl.alpha = 0
        }
        for i in 0...19
        {
            UIView.animate(withDuration: 1.0, delay: 0.05 * Double(i), usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [], animations: ({self.LblGrp[i].center.x = 123
                self.LblGrp[i].alpha = 1
            }), completion: nil)
        }
    }
}
