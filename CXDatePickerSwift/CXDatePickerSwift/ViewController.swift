//
//  ViewController.swift
//  CXDatePickerSwift
//
//  Created by 陈曦1 on 2018/9/20.
//  Copyright © 2018年 xi chen. All rights reserved.
//

import UIKit
import AVKit


class ViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 300, width: 100, height: 50))
        button.setTitle("按钮", for: UIControlState.normal)
        button.backgroundColor = UIColor.red
        button.addTarget(self, action:#selector(buttonClick), for: UIControlEvents.touchUpInside)
        
        self.view.addSubview(button)
        
//        AVAudioSession.sharedInstance().setCategory(<#T##category: String##String#>)
        
//        AVAudioSession.sharedInstance().setCategory = AVAudioSessionCategoryPlayback
        
        let picker = UIPickerView.init()
        picker.backgroundColor = UIColor.red
        picker.dataSource = self
        picker.delegate = self
        view.addSubview(picker)
        picker.selectRow(5, inComponent: 0, animated: true)
    
        print("222234\(NSDate.weekwithDate(date: NSDate.init()))")
    }

    @objc func buttonClick() {
        let picker = CXPickerSwift.init()
        picker.indexArray = ["MM","dd","yyyy"]
        picker.infiniteScroll = true
        
        picker.showDatePicker(view: self.view, maxDate: NSDate.dateWithStr(date: "2021-01-02 15:59:53", format: nil), minDate: NSDate.dateWithStr(date: "2001-10-02 15:59:53", format: nil), format: "yyyy-MM-dd", selectDate: NSDate(), determineBlock: { (picker, dateDict) in

            print("234234\(dateDict)")
            
        }) { (picker) in
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "12342432"
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
}

