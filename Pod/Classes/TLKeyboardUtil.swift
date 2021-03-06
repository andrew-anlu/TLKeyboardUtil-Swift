//
//  TLKeyboardUtil.swift
//  TLKeyboardUtil-Swift
//
//  Created by Andrew on 16/3/20.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}





/**
 *  存储所有输入框的字典{"输入框":"输入框的在window坐标系中的originY"}
 这是一个无序的，需要进行排序
 */
private var keyAllSubviewsDict: Void?
/**
 *  存储排序的输入框的数组
 */
private var keyInputViewSubViewArray :Void?;


open class TLKeyboardUtil: NSObject,TLKeyBoardAutoPopProtocol {
    

    
    fileprivate var prevBarItem:UIBarButtonItem?
    fileprivate var nextBarItem:UIBarButtonItem?
    fileprivate  var keyboardToolbar:UIToolbar?
    weak fileprivate var rootScrollView:UIScrollView?
    
    var isHasNavigationBar:Bool = true
    
    let SCREEN_WIDTH:CGFloat=UIScreen.main.bounds.width;
    let SCREEN_HEIGHT:CGFloat=UIScreen.main.bounds.height
    
    
    
    
    /// 单例模式
    
   public static let sharedInstance = TLKeyboardUtil()
    
 
    
   private override init() {
        super.init();
        initialized();
    }
    
    /**
     初始化一些数据
     - returns:
     */
    func initialized(){
        keyboardToolbar=createToolBar(frame: CGRect(x: 0, y: 0,width: SCREEN_WIDTH, height: 40));
        
        let notification:NotificationCenter=NotificationCenter.default;
        
        notification.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        notification.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    
    /**
     创建弹出键盘的工具条
     
     - returns: toolbar
     */
    func createToolBar(frame rect:CGRect)->UIToolbar{
        let toolbar:UIToolbar=UIToolbar(frame: rect);
        prevBarItem=UIBarButtonItem(title: "上一个", style:.plain, target: self, action: #selector(TLKeyboardUtil.prevAction(_:)))
        
        nextBarItem=UIBarButtonItem(title: "下一个", style: .plain, target: self, action: #selector(TLKeyboardUtil.nextAction(_:)))
        
        let doneBtn:UIBarButtonItem=UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(TLKeyboardUtil.finishAction(_:)));
        
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        
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
            i += 1;
        }
        if(index==0){
            //上一项 按钮不可用
            prevBarItem?.isEnabled=false;
            nextBarItem?.isEnabled=true;
        }else if(index==(subViewsArray?.count)!-1){
            nextBarItem?.isEnabled=false;
            prevBarItem?.isEnabled=true;
        }else{
            prevBarItem?.isEnabled=true;
            nextBarItem?.isEnabled=true;
        }
    }
    
    
    /**
     上一个
     */
    func prevAction(_ sender:AnyObject){
        let currentView:UIView?=getFirstResponder();
        
        if(currentView == nil){
            return
        }
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        if(subviewsArray == nil){
            return
        }
        
        var prevView:UIView?;
        var index:Int=1000;
        
        var i=0;
        for sub in subviewsArray!{
            if(sub as? UIView==currentView){
                index=i;
                break;
            }
            i += 1;
        }
        
        if(index==1000){
            
        }else if(index-1>=0){
            prevView=subviewsArray![index-1] as? UIView;
            prevView?.becomeFirstResponder();
            nextBarItem!.isEnabled=true;
        }else{
            prevBarItem!.isEnabled=false;
        }
    }
    /**
     下一个
     
     - parameter sender:
     */
    func nextAction(_ sender:AnyObject){
        let currentView:UIView?=getFirstResponder();
        
        if(currentView == nil){
            return
        }
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        var nextView:UIView?;
        var index:Int=1000;
        
        if(subviewsArray == nil){
            return
        }
        
        var i=0;
        for sub in subviewsArray!{
            if(sub as? UIView==currentView){
                index=i;
                break;
            }
            i += 1;
        }
        
        if(index==1000){
            
        }else if(index+1<subviewsArray!.count){
            nextView=subviewsArray![index+1] as? UIView;
            nextView?.becomeFirstResponder();
            prevBarItem!.isEnabled=true;
        }else{
            nextBarItem!.isEnabled=false;
        }
    }
    
    func finishAction(_ sender:AnyObject){
        
        let subArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        if(subArray == nil){
            return
        }
        
        for sub in subArray!{
            if(sub is UITextView){
                (sub as! UITextView).resignFirstResponder()
            }else{
                (sub as! UIView).resignFirstResponder();
            }
        }
    }
    
    // MARK: - 键盘弹出
    func keyboardWillShow(_ noti:Notification){
        let currentControl:UIView?=getFirstResponder();
        
        if(currentControl == nil)
        {
            return
        }
        //判断工具条上的按钮是否可用
        judgeToolbarItemEnabled(UIView: currentControl!);
        let rect:CGRect=((noti.userInfo![UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue)!;
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            var frame:CGRect=(self.rootScrollView?.frame)!;
            var y:Float=Float(self.rootScrollView!.frame.origin.y);
            
            
            var coverHeight:Float=self.isCover(view: currentControl!, height: Float(rect.size.height));
            if(coverHeight>0){
                coverHeight=fabsf(coverHeight);
                y = y - coverHeight;
                
                //设置scrollView可以滚动
                var contentHeight:CGFloat = self.rootScrollView!.frame.size.height+CGFloat(coverHeight)
                
                if(currentControl is UITextView){
                    contentHeight += 120
                }
                self.rootScrollView!.contentSize=CGSize(width: self.rootScrollView!.frame.size.width,height: contentHeight);
                
                
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
    }
    //MARK: 键盘退出
    func keyboardWillHide(){
        
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            
            self.rootScrollView?.frame=CGRect(x: 0, y: 0, width: self.SCREEN_WIDTH, height: self.SCREEN_HEIGHT);
            }, completion: nil);
    }
    
    
    //MARK: 如果键盘弹出，是否遮盖当前的控件
    func isCover(view:UIView,height keyboardHeight:Float)->Float{
        let windowPoint:CGPoint=(view.superview?.convert(view.frame.origin, to: UIApplication.shared.keyWindow))!;
        var result:Float=0;
        
        
        let topY:Float=64.0;
        let bottomY:Float=Float(SCREEN_HEIGHT) - keyboardHeight - 80;
        if(Float(windowPoint.y) > bottomY){
            result=Float(windowPoint.y) - 20 - bottomY;
        }
            
      
        else if(Float(windowPoint.y) < topY){//如果当前的控件被最上面的view或者导航条遮挡的情况
            //让当前View的Y 向下移动，originY增加
            result=Float(windowPoint.y)-20 - topY;
        }
        return result;
    }
    
    
//    public func addKeyboardAutoPopWithView(UIVIew view: UIView,isHasNavBar:Bool){
//       self.addKeyboardAutoPopWithView(UIVIew: view)
//        self.isHasNavigationBar = isHasNavBar
//    }
    
    //MARK:-APIS  TLKeyboardProtocol 实现
    open func addKeyboardAutoPopWithView(UIVIew view: UIView) {
        if let rootview=view as? UIScrollView{
            rootScrollView=rootview;
        }else{
            let scrollView:UIScrollView=UIScrollView(frame: view.bounds);
            for sub in view.subviews{
                scrollView.addSubview(sub);
            }
            view.insertSubview(scrollView, at: 0);
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
        
//        let tap:UITapGestureRecognizer=UITapGestureRecognizer(target: self, action:#selector(tapBackground));
//        rootScrollView?.addGestureRecognizer(tap);
    }
    
    //MARK: - 检查所有子视图和嵌套视图中的 InputField
    /**
     检查所有子视图和嵌套视图中的 InputField
     
     - parameter view:   当前遍历的视图
     - parameter originY: 当前视图的坐标系Y轴坐标
     */
    func checkedInputViewInRootView(UIVew view:UIView, y originY:CGFloat){
        for subView  in view.subviews{
            if(subView.isHidden==true){
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
                var key:NSNumber=NSNumber(value: (subOriginY+floatNumber) as Float);
                
                //如果是用苹果的自动布局技术，它的坐标是在运行后渲染计算的，所以这个时候，坐标都是0,0
                //手动让其key不同
                let keys = subDict?.allKeys as! [NSNumber]
                if keys.contains(key) == true{
                    key = NSNumber(value: key.floatValue + 10 as Float)
                }
                
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
        
        array=array.sorted { (obj1, obj2) -> Bool in
            return obj1.intValue < obj2.intValue;
        }
        
        let resultArray:NSMutableArray = NSMutableArray();
        
        for key in array{
            let view:UIView=inputDict![key] as! UIView;
            resultArray.add(view);
        }
        //将两个对象进行关联
        objc_setAssociatedObject(rootScrollView, &keyInputViewSubViewArray, resultArray,.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }
    
    //MARK: - 点击背景，退出键盘
    func tapBackground(){
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        guard subviewsArray?.count>0 else{
            return;
        }
        
        for sub in subviewsArray!{
            (sub as AnyObject).resignFirstResponder();
        }
        
    }
    
    //MARK:-获取页面上获取焦点的控件
    func getFirstResponder()->UIView?{
        
        let subviewsArray:NSMutableArray?=objc_getAssociatedObject(rootScrollView, &keyInputViewSubViewArray) as? NSMutableArray;
        
        guard subviewsArray?.count>0 else{
            return nil;
            
        }
        for sub in subviewsArray!{
            if(((sub as AnyObject).isFirstResponder) == true){
                return sub as? UIView;
            }
        }
        return nil;
    }
    
    
}
