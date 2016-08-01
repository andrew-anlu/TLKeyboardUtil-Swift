//
//  ViewController.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 03/19/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

import UIKit
import TLKeyboardUtil_Swift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white()
        // Do any additional setup after loading the view, typically from a nib.
        initView();
        
//        let dd:TLKeyboardUtil=TLKeyboardUtil.sharedInstance;
//        dd.addKeyboardAutoPopWithView(UIVIew: self.view);
        
        let dd:TLKeyboardUtil=TLKeyboardUtil.sharedInstance
        dd.addKeyboardAutoPopWithView(UIVIew: self.view);
        
        
    }

    
    func initView(){
        
        let btn1:UIButton=UIButton(frame:CGRect(x: 30, y: 50, width: 200, height: 40));
        btn1.setTitle("普通视图测试", for: UIControlState())
        btn1.setTitleColor(UIColor.red(), for: UIControlState())
        btn1.tag=10;
        btn1.addTarget(self, action: #selector(ViewController.navAction(_:)), for: .touchUpInside);
        self.view.addSubview(btn1);
        
        let btn2:UIButton=UIButton(frame:CGRect(x: 30, y: btn1.frame.maxY+20, width: 200, height: 40))
        btn2.titleLabel?.text="ScrollView视图测试";
        btn2.tag=20;
        btn2.setTitleColor(UIColor.red(), for: UIControlState())
        btn2.setTitle("ScrollView视图测试", for: UIControlState())
        btn2 .addTarget(self, action: #selector(ViewController.navAction(_:)), for: .touchUpInside);
        self.view.addSubview(btn2);
        
    }
    
    func navAction(_ sender:UIButton){
        if(sender.tag==10){
            let vc:FirstViewController=FirstViewController();
            self.navigationController?.pushViewController(vc, animated: true);
        }else{
            let vc:SecondViewController=SecondViewController();
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    
    
  
    

}

