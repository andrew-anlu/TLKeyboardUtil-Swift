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
        self.view.backgroundColor=UIColor.whiteColor()
        // Do any additional setup after loading the view, typically from a nib.
        initView();
        
//        let dd:TLKeyboardUtil=TLKeyboardUtil.sharedInstance;
//        dd.addKeyboardAutoPopWithView(UIVIew: self.view);
        
        var dd:TLKeyboardUtil=TLKeyboardUtil.sharedInstance;
        dd.addKeyboardAutoPopWithView(UIVIew: self.view);
        
        
    }

    
    func initView(){
        
        let btn1:UIButton=UIButton(frame:CGRectMake(30, 50, 200, 40));
        btn1.setTitle("普通视图测试", forState: .Normal)
        btn1.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn1.tag=10;
        btn1.addTarget(self, action: Selector("navAction:"), forControlEvents: .TouchUpInside);
        self.view.addSubview(btn1);
        
        let btn2:UIButton=UIButton(frame:CGRectMake(30, CGRectGetMaxY(btn1.frame
            )+20, 200, 40))
        btn2.titleLabel?.text="ScrollView视图测试";
        btn2.tag=20;
        btn2.setTitleColor(UIColor.redColor(), forState: .Normal)
        btn2.setTitle("ScrollView视图测试", forState: .Normal)
        btn2 .addTarget(self, action: Selector("navAction:"), forControlEvents: .TouchUpInside);
        self.view.addSubview(btn2);
        
    }
    
    func navAction(sender:UIButton){
        if(sender.tag==10){
            var vc:FirstViewController=FirstViewController();
            self.navigationController?.pushViewController(vc, animated: true);
        }else{
            var vc:SecondViewController=SecondViewController();
            self.navigationController?.pushViewController(vc, animated: true);
        }
    }
    
    
    
  
    

}

