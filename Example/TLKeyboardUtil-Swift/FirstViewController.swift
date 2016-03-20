//
//  FirstViewController.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 16/3/20.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.whiteColor()

        initView();
        
        let keyboardUtil:TLKeyboardUtil=TLKeyboardUtil.sharedInstance;
        keyboardUtil.addKeyboardAutoPopWithView(UIVIew: self.view);
    }

    
    func initView(){
        
        let width:CGFloat=UIScreen.mainScreen().bounds.width-40;
        
        var rect:CGRect=CGRectMake(20, 40, width-20*4, 30);
        let field1:UISearchBar=UISearchBar(frame: rect);
        self.view.addSubview(field1);
        
        rect=CGRectMake(20,100, width, 30);
        let field2:UITextField=createField(rect:rect, title: "第二个输入框");
        field2.placeholder="我是第二个输入框";
        self.view.addSubview(field2);
        
        rect=CGRectMake(20, CGRectGetMaxY(field2.frame)+20, width, 30);
        let field3:UITextField=createField(rect:rect, title: "第三个输入框");
        field3.placeholder="我是第三个输入框";
        self.view.addSubview(field3);
        
        rect=CGRectMake(20, CGRectGetMaxY(field3.frame)+20, width, 30);
        let field4:UITextField=createField(rect:rect, title: "第三个输入框");
        self.view.addSubview(field4);
        
        rect=CGRectMake(20, CGRectGetMaxY(field4.frame)+20, width, 30);
        let field5:UITextField=createField(rect:rect, title: "第四个输入框");
        self.view.addSubview(field5);
        
        rect=CGRectMake(20,UIScreen.mainScreen().bounds.height-120-64, width, 100);
        let field6:UITextView=UITextView(frame: rect);
        field6.backgroundColor=UIColor.grayColor();
        field6.text="请输入工作介绍";
        self.view.addSubview(field6);
        
     
        
    }

    func createField(rect rect:CGRect,title:String)->UITextField{
        let field:UITextField=UITextField(frame: rect);
        field.borderStyle = .Line;
        field.placeholder=title;
        return field;
    }
}
