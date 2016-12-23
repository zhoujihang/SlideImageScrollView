//
//  ImageBannerListModel.swift
//  SlideImageScrollView
//
//  Created by 周际航 on 2016/12/23.
//  Copyright © 2016年 com.maramara. All rights reserved.
//

import Foundation

class ImageBannerListModel {
    
    var list: [ImageBannerModel] = []
    
    static func fakeModel() -> ImageBannerListModel {
        let listModel = ImageBannerListModel()
        let array = ["http://g.hiphotos.baidu.com/zhidao/pic/item/91529822720e0cf37936ea670b46f21fbf09aa6d.jpg",
                     "http://e.hiphotos.baidu.com/zhidao/pic/item/6159252dd42a2834288f348b5bb5c9ea15cebf00.jpg",
                     "http://d.hiphotos.baidu.com/zhidao/pic/item/a9d3fd1f4134970a5b4666c892cad1c8a7865d1b.jpg",
                     "http://h.hiphotos.baidu.com/zhidao/pic/item/a08b87d6277f9e2fb8e27ab81930e924b999f3af.jpg",
                     "http://img3.duitang.com/uploads/blog/201503/10/20150310102133_ZUAaQ.thumb.700_0.jpeg",
                     "http://image15.poco.cn/mypoco/myphoto/20131113/00/5164525220131113002008064.jpg",
                     "http://cdn.duitang.com/uploads/blog/201503/10/20150310103859_33CX5.thumb.700_0.jpeg",
                     "http://img3.duitang.com/uploads/item/201502/18/20150218065055_hGV4U.jpeg"
                     ]
        for str in array {
            let model = ImageBannerModel()
            model.imageUrl = str
            model.title = ""
            listModel.list.append(model)
        }
        return listModel
    }
    
}

class ImageBannerModel {
    
    var imageUrl: String = ""
    
    var title: String = ""
    
}

