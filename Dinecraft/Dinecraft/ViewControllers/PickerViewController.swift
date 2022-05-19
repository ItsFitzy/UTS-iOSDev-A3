//
//  PickerViewController.swift
//  Dinecraft
//
//  Created by Tak Chung on 19/5/2022.
//

import UIKit

class PickerViewController: UIViewController {
    @IBOutlet weak var FruitPicker: UIPickerView!
    
    var fruitdata: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FruitPicker.delegate = self
        FruitPicker.dataSource = self
        let keywords: Keywords = Keywords()
        fruitdata = keywords.fruits
    }
}

extension PickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return fruitdata.count
    }
    
}

extension PickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fruitdata[row]
    }
}
