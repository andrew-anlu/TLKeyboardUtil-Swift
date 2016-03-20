//
//  ViewController.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 03/19/2016.
//  Copyright (c) 2016 Andrew. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initView();
        let dd:TLKeyboardUtil=TLKeyboardUtil.sharedInstance;
        dd.addKeyboardAutoPopWithView(UIVIew: self.view);
    }

    
    func initView(){
        var rect:CGRect=CGRectMake(20, 40, 200, 30);
        let field1:UITextField=createField(rect: rect, title: "第一个输入框");
        self.view.addSubview(field1);
        
        rect=CGRectMake(20,100, 200, 30);
        let field2:UITextField=createField(rect:rect, title: "第二个输入框");
        self.view.addSubview(field2);
        
    }
    
    func createField(rect rect:CGRect,title:String)->UITextField{
        let field:UITextField=UITextField(frame: rect);
        field.borderStyle = .Line;
        field.placeholder=title;
        return field;
    }
    

}

