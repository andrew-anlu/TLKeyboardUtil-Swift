//
//  TLKeyboardUtil.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 16/3/20.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit




/**
*  存储所有输入框的字典{"输入框":"输入框的在window坐标系中的originY"}
这是一个无序的，需要进行排序
*/
private var keyAllSubviewsDict: Void?
/**
*  存储排序的输入框的数组
*/
private var keyInputViewSubViewArray :Void?;


class TLKeyboardUtil: NSObject,TLKeyBoardAutoPopProtocol {

    private var prevBarItem:UIBarButtonItem?
    private var nextBarItem:UIBarButtonItem?
    private  var keyboardToolbar:UIToolbar?
    weak private var rootScrollView:UIScrollView?
 
    let SCREEN_WIDTH:CGFloat=UIScreen.mainScreen().bounds.width;
    let SCREEN_HEIGHT:CGFloat=UIScreen.mainScreen().bounds.height
    
    
   
    
    /// 单例模式
    class var sharedInstance: TLKeyboardUtil {
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : TLKeyboardUtil? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = TLKeyboardUtil()
        }
        return Static.instance!;
    }
    
   override init() {
      super.init();
      initialized();
    }
    
    /**
     初始化一些数据
     - returns:
     */
    func initialized(){
        keyboardToolbar=createToolBar(frame: CGRectMake(0, 0,SCREEN_WIDTH, 40));
        
        let notification:NSNotificationCenter=NSNotificationCenter.defaultCenter();
       
        notification.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil);
        notification.addObserver(self, selector: Selector("keyboardWillHide"), name: UIKeyboardWillHideNotification, object: nil);
    }
    
    /**
     创建弹出键盘的工具条
     
     - returns: toolbar
     */
    func createToolBar(frame rect:CGRect)->UIToolbar{
        let toolbar:UIToolbar=UIToolbar(frame: rect);
        prevBarItem=UIBarButtonItem(title: "上一个", style:.Plain, target: self, action: Selector("prevAction:"))
        
        nextBarItem=UIBarButtonItem(title: "下一个", style: .Plain, target: self, action: Selector("nextAction:"))
        
        let doneBtn:UIBarButtonItem=UIBarButtonItem(title: "完成", style: .Plain, target: self, action: Selector("finishAction:"));
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)

        
        toolbar.items=[nextBarItem!,prevBarItem!,flexBarButton,doneBtn];
        return toolbar;
        
    }
    
    
    //MARK: - 判断是否 '上一个',‘下一个’ 按钮是否可用
    /**
    *  判断是否 '上一个',‘下一个’ 按钮是否可用
    *
    *  @param currentInput
    */
    func judgeToolbarItemEnabled(UIView currentView:UIView){
        let subViewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        var index=1000;
        var i=0;
        for subView in subViewsArray!{
            if(currentView==subView as! UIView){
                index=i;
                break;
            }
            i++;
        }
        if(index==0){
          //上一项 按钮不可用
            prevBarItem?.enabled=false;
            nextBarItem?.enabled=true;
        }else if(index==(subViewsArray?.count)!-1){
            nextBarItem?.enabled=false;
            prevBarItem?.enabled=true;
        }else{
            prevBarItem?.enabled=true;
            nextBarItem?.enabled=true;
        }
    }

    
    /**
     上一个
     */
    func prevAction(sender:AnyObject){
     print("上一个")
        let currentView:UIView=getFirstResponder()!;
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        var prevView:UIView?;
        var index:Int=1000;
       
        var i=0;
        for sub in subviewsArray!{
            if(sub as! UIView==currentView){
                index=i;
                break;
            }
            i++;
        }
        
        if(index==1000){
            
        }else if(index-1>=0){
            prevView=subviewsArray![index-1] as? UIView;
            prevView?.becomeFirstResponder();
            nextBarItem!.enabled=true;
        }else{
            prevBarItem!.enabled=false;
        }
    }
    /**
     下一个
     
     - parameter sender:
     */
    func nextAction(sender:AnyObject){
     print("下一个")
        let currentView:UIView=getFirstResponder()!;
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        var nextView:UIView?;
        var index:Int=1000;
        
        var i=0;
        for sub in subviewsArray!{
            if(sub as! UIView==currentView){
                index=i;
                break;
            }
            i++;
        }
        
        if(index==1000){
            
        }else if(index+1<subviewsArray!.count){
            nextView=subviewsArray![index+1] as? UIView;
            nextView?.becomeFirstResponder();
            prevBarItem!.enabled=true;
        }else{
            nextBarItem!.enabled=false;
        }
    }
    
    func finishAction(sender:AnyObject){
        print("done");
        
        let subArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        for sub in subArray!{
            (sub as! UIView).resignFirstResponder();
        }
    }
    
    // MARK: - 键盘弹出
    func keyboardWillShow(noti:NSNotification){
        let currentControl:UIView?=getFirstResponder();
        //判断工具条上的按钮是否可用
        judgeToolbarItemEnabled(UIView: currentControl!);
        let rect:CGRect=(noti.userInfo![UIKeyboardFrameEndUserInfoKey]?.CGRectValue)!;
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            var frame:CGRect=(self.rootScrollView?.frame)!;
            var y:Float=Float(self.rootScrollView!.frame.origin.y);
            
            
            var coverHeight:Float=self.isCover(view: currentControl!, height: Float(rect.size.height));
            if(coverHeight>=0){
               coverHeight=fabsf(coverHeight);
                y = y - coverHeight;
                
                //设置scrollView可以滚动
                self.rootScrollView!.contentSize=CGSizeMake(self.rootScrollView!.frame.size.width,self.rootScrollView!.frame.size.height+CGFloat(coverHeight));
            }else{
                coverHeight=fabsf(coverHeight);
                y += coverHeight;
            }
            
            frame.origin.y=CGFloat(y);
            self.rootScrollView!.frame=frame;
            }, completion: nil);
     /*
        UIView *currentControl=[self getFirstResponder];
        [self judgeToolbarItemEnabled:currentControl];
        
        NSLog(@"当前监控的控件的CGRect=%@",NSStringFromCGRect(currentControl.frame));
        
        CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"弹出键盘的CGRect=%@",NSStringFromCGRect(rect));
        
        [UIView animateWithDuration:0.2 animations:^{
        CGRect frame=_rootScrollView.frame;
        CGFloat y = frame.origin.y;
        
        float coverHeight=[self isCover:currentControl keyboardHeight:rect.size.height];
        if(coverHeight>=0){
        coverHeight=fabsf(coverHeight);
        y=y-coverHeight;
        
        //设置scrollView可以滚动
        _rootScrollView.contentSize=CGSizeMake(_rootScrollView.frame.size.width,_rootScrollView.frame.size.height+coverHeight);
        
        }else if(coverHeight<0){
        coverHeight=fabsf(coverHeight);
        y+=coverHeight;
        }
        frame.origin.y=y;
        _rootScrollView.frame=frame;
        }];
        */
      print("键盘弹出来了")
    }
    //MARK: 键盘退出
    func keyboardWillHide(){
        print("键盘退出了");
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            
            self.rootScrollView?.frame=CGRectMake(0, 0, self.SCREEN_WIDTH, self.SCREEN_HEIGHT);
            self.rootScrollView?.contentSize=CGSizeZero;
            }, completion: nil);
    }
    
    
    //MARK: 如果键盘弹出，是否遮盖当前的控件
    func isCover(view view:UIView,height keyboardHeight:Float)->Float{
        let windowPoint:CGPoint=(view.superview?.convertPoint(view.frame.origin, toView: UIApplication.sharedApplication().keyWindow))!;
        var result:Float=0;
        
        let topY:Float=74.0;
        let bottomY:Float=Float(SCREEN_HEIGHT) - keyboardHeight - 80;
        if(Float(windowPoint.y) > bottomY){
            result=Float(windowPoint.y) - bottomY + Float(view.frame.size.height);
        }else if(Float(windowPoint.y) < topY){//如果当前的控件被最上面的view或者导航条遮挡的情况
           //让当前View的Y 向下移动，originY增加
            result=Float(windowPoint.y)-20 - topY;
        }
        return result;
    }


    

//MARK:-APIS  TLKeyboardProtocol 实现
    func addKeyboardAutoPopWithView(UIVIew view: UIView) {
        if let rootview=view as? UIScrollView{
            rootScrollView=rootview;
        }else{
            let scrollView:UIScrollView=UIScrollView(frame: view.bounds);
            for sub in view.subviews{
                scrollView.addSubview(sub);
            }
            view.insertSubview(scrollView, atIndex: 0);
            rootScrollView=scrollView;
         }
        
        //存储所有输入框的字典
        let subviewDict:NSMutableDictionary=NSMutableDictionary();
        objc_setAssociatedObject(rootScrollView,&keyAllSubviewsDict, subviewDict, .OBJC_ASSOCIATION_RETAIN_NONATOMIC);
       
        //检查所有的子视图的输入框
        checkedInputViewInRootView(UIVew:rootScrollView!, y: rootScrollView!.frame.origin.y);
        
        //排序
        sortSubViewByOriginYinWindow();
        //设置工具条
        setInputAccessViewWithInputView();
        
        let tap:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action: Selector("tapBackground"));
        rootScrollView?.addGestureRecognizer(tap);
    }
    
    //MARK: - 检查所有子视图和嵌套视图中的 InputField
    /**
     检查所有子视图和嵌套视图中的 InputField
     
     - parameter view:   当前遍历的视图
     - parameter originY: 当前视图的坐标系Y轴坐标
     */
    func checkedInputViewInRootView(UIVew view:UIView, y originY:CGFloat){
        for subView  in view.subviews{
            if(subView.hidden==true){
                continue;
            }
            
            if(subView is UITextField ||
               subView is UITextView  ||
            subView is UISearchBar){
             
                    let subDict:NSMutableDictionary?=objc_getAssociatedObject(rootScrollView,&keyAllSubviewsDict) as? NSMutableDictionary;
               
                    guard ((subDict) != nil) else{
                        return;
                    }
                    
                    let subOriginY:Float=Float(subView.frame.origin.y);
                    let floatNumber:Float=Float(originY)+subOriginY;
                    let key:NSNumber=NSNumber(float:(subOriginY+floatNumber));
                    //放入字典中
                    subDict!.setObject(subView, forKey: key);
            }
            
            if(subView.subviews.count>0){
                checkedInputViewInRootView(UIVew: subView, y: originY+subView.frame.origin.y);
            }
 
        }
    }
   
    
    /**
     给每一个输入框设置工具条
     */
    func setInputAccessViewWithInputView(){
    
        
        let inputArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
      
        guard inputArray?.count>0 else{
            return;
        }
        
        for sub in inputArray!{
            if let subView = sub as? UITextView{
                subView.inputAccessoryView=keyboardToolbar;
            }else if let subView = sub as? UITextField{
                subView.inputAccessoryView=keyboardToolbar;
            }else if let subView = sub as? UISearchBar{
                subView.inputAccessoryView=keyboardToolbar;
            }
        }

    }
    
    //MARK:对所有的输入框按照 originY的高低来排序
    /**
     对所有的输入框按照 originY的高低来排序
     */
    func sortSubViewByOriginYinWindow(){
        
        let inputDict:NSMutableDictionary?=objc_getAssociatedObject(rootScrollView, &keyAllSubviewsDict) as? NSMutableDictionary;
    
        guard inputDict?.count>0 else{
            return;
        }
        
        
        var array:Array<NSNumber>=inputDict!.allKeys as! Array<NSNumber>
        
        array=array.sort { (AnyObject obj1, AnyObject obj2) -> Bool in
            return obj1.integerValue < obj2.integerValue;
        }
        
        let resultArray:NSMutableArray = NSMutableArray();
        print("循环如下:\(array)")
        
        for key in array{
            let view:UIView=inputDict![key] as! UIView;
            resultArray.addObject(view);
        }
        //将两个对象进行关联
        objc_setAssociatedObject(rootScrollView, &keyInputViewSubViewArray, resultArray,.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        print("排序后的数组为:\(resultArray)");
    
    }
    
    //MARK: - 点击背景，退出键盘
    func tapBackground(){
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        guard subviewsArray?.count>0 else{
            print("执行guradelse中的代码了")
            return;
        }
        
        for sub in subviewsArray!{
            sub.resignFirstResponder();
        }
        
    }
    
    //MARK:-获取页面上获取焦点的控件
    func getFirstResponder()->UIView?{
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        guard subviewsArray?.count>0 else{
            return nil;
            
        }
        for sub in subviewsArray!{
            if(sub.isFirstResponder()){
                return sub as? UIView;
            }
        }
        return nil;
    }

    
}
