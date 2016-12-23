//
//  ViewController.swift
//  SlideImageScrollView
//
//  Created by 周际航 on 2016/12/23.
//  Copyright © 2016年 com.maramara. All rights reserved.
//

import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    fileprivate lazy var imageScrollView1 = SlideImageScrollView(frame: CGRect.zero)
    fileprivate lazy var imageScrollView2 = SlideImageScrollView(frame: CGRect.zero)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupConstraints()
        self.setupData()
    }
    func setupViews() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(self.imageScrollView1)
        self.view.addSubview(self.imageScrollView2)
        
        self.imageScrollView1.delegate = self
        self.imageScrollView2.delegate = self
    }
    func setupConstraints() {
        // frame
        let width = UIScreen.main.bounds.size.width
        self.imageScrollView1.frame = CGRect(x: 0, y: 64, width: width, height: 200)
        
        // constraint
        self.imageScrollView2.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: self.imageScrollView2, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: self.imageScrollView2, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self.imageScrollView2, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -20)
        let height = NSLayoutConstraint(item: self.imageScrollView2, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
        self.view.addConstraints([left, right, bottom])
        self.imageScrollView2.addConstraint(height)
    }
    func setupData() {
        self.imageScrollView1.imageBannerListModel = ImageBannerListModel.fakeModel()
        self.imageScrollView2.imageBannerListModel = ImageBannerListModel.fakeModel()
        // self.imageScrollView2.imageBannerListModel = nil
        
        self.imageScrollView1.placeHoldImage = UIImage(named: "默认图片.jpg")
        self.imageScrollView2.placeHoldImage = UIImage(named: "默认图片.jpg")
    }
}

extension ViewController: SlideImageScrollViewDelegate {
    
    func slideImageScrollView(_ view: SlideImageScrollView, didClick imageModel: ImageBannerModel) {
        debugPrint("\(type(of: self)): \(#function) line:\(#line) \(imageModel.imageUrl)")
    }
    
}


