//
//  YSJDropMenuView.swift
//  YSJDropMenu_Swift
//
//  Created by 闫树军 on 16/5/16.
//  Copyright © 2016年 闫树军. All rights reserved.
//

import UIKit

let kScreenWidth = UIScreen.mainScreen().bounds.size.width
let kScreenHeight = UIScreen.mainScreen().bounds.size.height
let ysjDropMenuTag = 1000


protocol YSJDropMenuViewDelegate {
    
    func dropMenuselectedItem(index:NSInteger)
    
    func dropMenuSelectedTitle(index: NSInteger)
}


class YSJDropMenuView: UIView {
    
    private var headerView  : UIView!
    private var backView            : UIView!
    private var lineImageView       : UIImageView!
    
    private var menuTableView       : UITableView!
    private var _titleItems         : NSArray!
    private var _menuItems          : NSArray!
    private var isShow              : Bool = false
    private var _selectedItem       : Int = 1
    var delegate                    :YSJDropMenuViewDelegate?
    

   internal init(frame: CGRect ,Items:NSArray ,menuItem:NSArray) {
        super.init(frame:frame)
    
        _titleItems = Items;
        _menuItems = menuItem
        configSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configSubView(){
        backgroundColor = UIColor.whiteColor()
        headerView = UIView.init(frame: CGRectMake(0, 0, frame.size.width, frame.size.height))
        for item in 0..._titleItems.count-1 {
            
            let titleBtn = UIButton.init(type: .System)
            titleBtn.frame = CGRectMake(0 + CGFloat(item) * kScreenWidth/CGFloat( _titleItems.count), 0, kScreenWidth/CGFloat( _titleItems.count), 40)
            titleBtn .setTitleColor(UIColor.blackColor(), forState: .Normal)
            titleBtn.titleLabel?.font = UIFont.systemFontOfSize(12.0)
            titleBtn .setTitle(_titleItems[item] as? String, forState: .Normal)
            titleBtn.addTarget(self, action: #selector(YSJDropMenuView.titleAction(_:)), forControlEvents: .TouchUpInside)
            titleBtn.tag = ysjDropMenuTag + item
            headerView.addSubview(titleBtn)
            
            
            let verImageView  = UIImageView.init(frame: CGRectMake(CGFloat(item) * kScreenWidth/CGFloat( _titleItems.count) - 1, 12, 1, 16))
            verImageView.backgroundColor = UIColor.lightGrayColor()
            headerView.addSubview(verImageView)
        }
        
        
        let bottomImageView = UIImageView.init(frame: CGRectMake(0, frame.size.height - 0.5, kScreenWidth, 0.5))
        bottomImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        headerView.addSubview(bottomImageView)
        
        lineImageView = UIImageView.init(frame: CGRectMake(0, frame.size.height - 2, kScreenWidth/CGFloat( _titleItems.count), 2))
        lineImageView.backgroundColor = UIColor.redColor()
        headerView.addSubview(lineImageView)
        self.addSubview(headerView)
        
        
        /*****************  ********************/
        
        backView = UIView(frame:CGRectMake(0,CGRectGetHeight(frame)+100,kScreenWidth,kScreenHeight))
        backView.backgroundColor = UIColor.blackColor()
        backView.hidden = false
        backView.alpha = 0
        
        backView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(YSJDropMenuView.hidden)))
        
        menuTableView = UITableView.init(frame: CGRectMake(0, CGRectGetHeight(frame), kScreenWidth, 0), style: .Plain)
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.hidden = true
    }
    
    
    func titleAction(btn:UIButton) {
        
        _selectedItem = btn.tag - ysjDropMenuTag

        if _selectedItem == _titleItems.count - 1 {
            
            isShow = !isShow
            
            if isShow {
                
                menuTableView.hidden = false
                backView.hidden = false
                menuTableView.frame = CGRectMake(0, self.frame.height + 100, kScreenWidth, 0)
                self.superview?.addSubview(menuTableView)
                self.superview?.addSubview(backView)
                self.superview?.insertSubview(backView, belowSubview: menuTableView)
                UIView.animateWithDuration(0.1, animations: {
                    self.menuTableView.frame.size.height = 40 * CGFloat(self._menuItems.count)
                    self.backView.alpha = 0.6
                })
                
                menuTableView.reloadData()
                
            }else{
                hidden()
            }
        }else{
            
            delegate?.dropMenuSelectedTitle(_selectedItem)
            
            UIView.animateWithDuration(0.3) {
                self.lineImageView.center = CGPointMake(btn.center.x, self.frame.size.height - 1)
            }
        }
        

    }
    
    func hidden() {
        isShow = false
        
        UIView.animateWithDuration(0.1, animations: {
            
            self.menuTableView.frame.size.height = 0.0
            self.backView.alpha = 0
            }) { (ret) in
                self.menuTableView.hidden = true
                self.backView.hidden = true
                self.menuTableView.removeFromSuperview()
                self.backView.removeFromSuperview()
        }
        
    }


}


extension YSJDropMenuView :UITableViewDelegate{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _menuItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("menu")
        if cell == nil {
            cell = UITableViewCell.init(style: .Default, reuseIdentifier: "menu")
        }
        cell?.textLabel?.text = _menuItems[indexPath.row] as? String
        cell?.textLabel?.font = UIFont.systemFontOfSize(14.0)
        cell?.selectionStyle = UITableViewCellSelectionStyle.None
        return cell!
    }
}

extension YSJDropMenuView :UITableViewDataSource{
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let btn = self.viewWithTag(_titleItems.count - 1 + 1000) as! UIButton
        btn .setTitle(_menuItems[indexPath.row] as? String, forState: .Normal)
        delegate?.dropMenuselectedItem(indexPath.row)
        hidden()
    }
}
