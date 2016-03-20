//
//  ControlUtils.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 16/3/20.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class ControlUtils: NSObject {

    /**
     创建弹出键盘的工具条
     
     - returns: toolbar
     */
    func createToolBar(frame rect:CGRect)->UIToolbar{
//        UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:rect];
//        _nextBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"下一个" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction:)];
//        _prevBarBtn=[[UIBarButtonItem alloc]initWithTitle:@"上一个" style:UIBarButtonItemStylePlain target:self action:@selector(prevAction:)];
//        
//        UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(finishAction:)];
//        
//        UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//        toolbar.items=@[_nextBarBtn,_prevBarBtn,spaceItem,doneBtn];
//        return toolbar;
        
        var toolbar:UIToolbar=UIToolbar(frame: rect);
        
        
        
        return toolbar;
        
    }
}
