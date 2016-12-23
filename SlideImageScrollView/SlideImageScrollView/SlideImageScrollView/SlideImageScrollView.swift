//
//  SlideImageScrollView.swift
//  SlideImageScrollView
//
//  Created by 周际航 on 2016/12/23.
//  Copyright © 2016年 com.maramara. All rights reserved.
//

import UIKit
import Kingfisher

protocol SlideImageScrollViewDelegate {
    func slideImageScrollView(_ view: SlideImageScrollView, didClick imageModel: ImageBannerModel)
}

class SlideImageScrollView: UIView {
    var imageBannerListModel: ImageBannerListModel? {
        didSet {
            self.didSetImageListModel()
        }
    }
    var placeHoldImage: UIImage? {
        didSet {
            self.didSetPlaceHolder()
        }
    }
    var delegate: SlideImageScrollViewDelegate?
    
    fileprivate var currentIndex = 0
    fileprivate let backdropScrollView = UIScrollView()
    fileprivate let imageView1 = UIImageView()
    fileprivate let imageView2 = UIImageView()
    fileprivate let imageView3 = UIImageView()
    fileprivate var timer: Timer?
    
    fileprivate var viewWidth: CGFloat = 0              // 记录当前视图宽度，用来判断是否需要重设中点位置
    fileprivate var isPreparedToScroll = true           // 记录视图是否已经准备好处理滑动代理方法
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.setupViews()
        self.setupTimer()
        self.setupData()
    }
    func setupViews() {
        self.backgroundColor = UIColor.white
        self.addSubview(self.backdropScrollView)
        self.backdropScrollView.addSubview(self.imageView1)
        self.backdropScrollView.addSubview(self.imageView2)
        self.backdropScrollView.addSubview(self.imageView3)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapImageView(tap:)))
        self.imageView2.addGestureRecognizer(tap)
        self.imageView2.isUserInteractionEnabled = true
        
        self.backdropScrollView.showsHorizontalScrollIndicator = false
        self.backdropScrollView.isPagingEnabled = true
        self.backdropScrollView.bounces = false
        self.backdropScrollView.delegate = self
        
        self.imageView1.contentMode = .scaleAspectFill
        self.imageView1.clipsToBounds = true
        self.imageView2.contentMode = .scaleAspectFill
        self.imageView2.clipsToBounds = true
        self.imageView3.contentMode = .scaleAspectFill
        self.imageView3.clipsToBounds = true
    }
    func setupData() {
        self.resetCurrentIndex(0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bounds = self.bounds
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        
        self.isPreparedToScroll = false
        // 每次修改 frame 会触发 scrollViewDidScroll 方法，同时 contentOffset 变为 (0, 0)
        self.backdropScrollView.frame = bounds
        self.backdropScrollView.contentSize = CGSize(width: width*3, height: height)
        self.isPreparedToScroll = true
        
        self.imageView1.frame = CGRect(x: 0, y: 0, width: width, height: height)
        self.imageView2.frame = CGRect(x: width, y: 0, width: width, height: height)
        self.imageView3.frame = CGRect(x: width*2, y: 0, width: width, height: height)
        
        if self.viewWidth != width {
            self.viewWidth = width
            self.resetContentOffset()
        }
    }
    
    @objc fileprivate func tapImageView(tap: UITapGestureRecognizer) {
        guard let listModel = self.imageBannerListModel else {return}
        guard self.currentIndex < listModel.list.count else {return}
        guard self.currentIndex >= 0 else {return}
        
        let model = listModel.list[self.currentIndex]
        self.delegate?.slideImageScrollView(self, didClick: model)
    }
}
// MARK: - 扩展 滑动代理
extension SlideImageScrollView: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.setupTimer()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard self.viewWidth != 0 else {return}
        guard self.isPreparedToScroll else {return}
        
        let offsetX = self.backdropScrollView.contentOffset.x
        let width = self.backdropScrollView.bounds.size.width
        let count = self.imageBannerListModel?.list.count ?? 0
        if offsetX == 0 {
            debugPrint("\(type(of: self)): \(#function) line:\(#line) 111")
            // 左滑动
            let newIndex = count==0 ? 0 : (self.currentIndex + count - 1) % count
            self.resetCurrentIndex(newIndex)
        } else if offsetX == width*2 {
            // 右滑动
            let newIndex = count==0 ? 0 : (self.currentIndex + 1) % count
            self.resetCurrentIndex(newIndex)
        }
    }
    fileprivate func resetCurrentIndex(_ index: Int) {
        self.currentIndex = index
        self.resetCurrentImage()
        self.resetContentOffset()
    }
    // 根据 currentIndex 的值，重设显示的图片
    fileprivate func resetCurrentImage() {
        guard let listModel = self.imageBannerListModel else {return}
        let count = listModel.list.count
        
        self.currentIndex = self.currentIndex < count ? self.currentIndex : count-1
        self.currentIndex = self.currentIndex >= 0 ? self.currentIndex : 0
        
        let index1 = (self.currentIndex + count - 1) % count
        let index2 = self.currentIndex
        let index3 = (self.currentIndex + 1) % count
        
        let url1 = URL(string: listModel.list[index1].imageUrl)
        let url2 = URL(string: listModel.list[index2].imageUrl)
        let url3 = URL(string: listModel.list[index3].imageUrl)
        
        self.imageView1.kf.setImage(with: url1, placeholder: self.placeHoldImage)
        self.imageView2.kf.setImage(with: url2, placeholder: self.placeHoldImage)
        self.imageView3.kf.setImage(with: url3, placeholder: self.placeHoldImage)
    }
    fileprivate func resetContentOffset() {
        let width = self.bounds.size.width
        self.backdropScrollView.setContentOffset(CGPoint(x: width, y: 0) , animated: false)
    }
}
// MARK: - 扩展 设置数据源
extension SlideImageScrollView {
    fileprivate func didSetImageListModel() {
        guard let listModel = self.imageBannerListModel else {
            self.didSetPlaceHolder()
            return
        }
        guard !listModel.list.isEmpty else {
            self.didSetPlaceHolder()
            return
        }
        self.resetCurrentIndex(0)
    }
}
// MARK: - 扩展 PlaceHolder
extension SlideImageScrollView {
    fileprivate func didSetPlaceHolder() {
        if self.imageBannerListModel == nil || self.imageBannerListModel!.list.isEmpty {
            self.imageView1.image = self.placeHoldImage
            self.imageView2.image = self.placeHoldImage
            self.imageView3.image = self.placeHoldImage
            return
        }
    }
}

// MARK: - 扩展 定时器任务
extension SlideImageScrollView {
    fileprivate func setupTimer() {
        self.removeTimer()
        self.timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(timerTask), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    fileprivate func removeTimer() {
        self.timer?.invalidate()
        self.timer = nil;
    }
    @objc func timerTask() {
        let width = self.bounds.size.width
        let newOffset = CGPoint(x: width*2, y: 0)
        self.backdropScrollView.setContentOffset(newOffset, animated: true)
    }
}



