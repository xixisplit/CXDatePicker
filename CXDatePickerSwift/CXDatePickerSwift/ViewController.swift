//
//  ViewController.swift
//  CXDatePickerSwift
//
//  Created by 陈曦1 on 2018/9/20.
//  Copyright © 2018年 xi chen. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let picker = CXPickerSwift.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: 100))
        
        picker.showDatePicker(view: self.view, maxDate: nil, minDate: nil, format: "yyyy-MM", selectDate: nil, determineBlock: { (picker, dateDict) in
            
        }) { (picker) in
            
        }
        
        
        self.view.addSubview(picker)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

