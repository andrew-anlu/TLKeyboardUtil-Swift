//
//  FirstViewController.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 16/3/20.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import TLKeyboardUtil_Swift


class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white

        initView();
        
    
        let keyboardUtil:TLKeyboardUtil=TLKeyboardUtil.sharedInstance
        keyboardUtil.addKeyboardAutoPopWithView(UIVIew: self.view);
        
//        keyboardUtil.addKeyboardAutoPopWithView(UIVIew: view, isHasNavBar: false)

    }

    
    func initView(){
        
        let width:CGFloat=UIScreen.main.bounds.width-40;
        
        var rect:CGRect=CGRect(x: 20, y: 0, width: width-20*4, height: 30);
        let field1:UISearchBar=UISearchBar(frame: rect);
        self.view.addSubview(field1);
        
        rect=CGRect(x: 20,y: 100, width: width, height: 30);
        let field2:UITextField=createField(rect:rect, title: "第二个输入框");
        field2.placeholder="我是第二个输入框";
        self.view.addSubview(field2);
        
        rect=CGRect(x: 20, y: field2.frame.maxY+20, width: width, height: 30);
        let field3:UITextField=createField(rect:rect, title: "第三个输入框");
        field3.placeholder="我是第三个输入框";
        self.view.addSubview(field3);
        
        rect=CGRect(x: 20, y: field3.frame.maxY+20, width: width, height: 30);
        let field4:UITextField=createField(rect:rect, title: "第三个输入框");
        self.view.addSubview(field4);
        
        rect=CGRect(x: 20, y: field4.frame.maxY+20, width: width, height: 30);
        let field5:UITextField=createField(rect:rect, title: "第四个输入框");
        self.view.addSubview(field5);
        
        rect=CGRect(x: 20,y: UIScreen.main.bounds.height-120-64, width: width, height: 100);
        let field6:UITextView=UITextView(frame: rect);
        field6.backgroundColor=UIColor.gray;
        field6.text="请输入工作介绍";
        self.view.addSubview(field6);
        
     
        
    }

    func createField(rect:CGRect,title:String)->UITextField{
        let field:UITextField=UITextField(frame: rect);
        field.borderStyle = .line;
        field.placeholder=title;
        return field;
    }
}
