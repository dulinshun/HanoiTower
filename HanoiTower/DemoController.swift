//
//  DemoController.swift
//  iOSDemo
//
//  Created by top on 2020/8/13.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class DemoController: UIViewController {
    
    let towerView = TowerView()
    
    let slider = UISlider()
    
    let lblCount = UILabel()
    
    private var totalViews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "汉诺塔演示"
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "重置", style: .plain, target: self, action: #selector(reset)),
            UIBarButtonItem(title: "开始", style: .plain, target: self, action: #selector(runDemo))
        ]
        
        towerView.frame = CGRect(x: 12, y: 200, width: view.bounds.width - 24, height: 300)
        view.addSubview(towerView)
        
        slider.frame = CGRect(x: 12, y: towerView.frame.maxY + 20, width: towerView.bounds.width - 40, height: 30)
        slider.minimumValue = 1
        slider.maximumValue = 9
        slider.value = 4
        slider.addTarget(self, action: #selector(countChanged), for: .valueChanged)
        view.addSubview(slider)
        
        lblCount.frame = CGRect(x: slider.frame.maxX + 10, y: slider.frame.minY, width: 30, height: 30)
        lblCount.textAlignment = .center
        view.addSubview(lblCount)
            
        countChanged()
    }
    
    @objc func countChanged() {
        let count = Int(slider.value)
        lblCount.text = "\(count)"
        towerView.set(plateCount: count)
    }
    
    @objc func runDemo() {
        towerView.startAutoRun()
    }
    
    @objc func reset() {
        towerView.reset()
    }
}

