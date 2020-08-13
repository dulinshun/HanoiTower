//
//  TowerView.swift
//  HanoiTower
//
//  Created by top on 2020/8/12.
//  Copyright © 2020 top. All rights reserved.
//

import UIKit

class Plate: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        backgroundColor = .purple
    }
}

class TowerCloumn: UIControl {

    /// 垂直线
    let verticalSeparator = UIView()

    /// 所有的盘子
    var plates: [Plate] = []

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .lightGray

        verticalSeparator.backgroundColor = .black
        verticalSeparator.layer.cornerRadius = 5
        verticalSeparator.layer.masksToBounds = true
        addSubview(verticalSeparator)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height
        verticalSeparator.bounds = CGRect(x: 0, y: 0, width: 10, height: height)
        verticalSeparator.center = CGPoint(x: width / 2, y: height / 2)
    }

    func clearPlates() {
        for plate in plates {
            plate.removeFromSuperview()
        }
        plates.removeAll()
    }

    func remove(plate: Plate) {
        if let index = plates.firstIndex(of: plate) {
            plates.remove(at: index)
        }
    }

    func add(plate: Plate) {
        plates.append(plate)
    }
}

class TowerView: UIView {

    /// 底部线
    private let bottomLine = UIView()

    /// 左侧列
    private let leftCloumn = TowerCloumn()

    /// 中心列
    private let centerCloumn = TowerCloumn()

    /// 右侧列
    private let rightCloumn = TowerCloumn()

    /// 底座高度
    private var bottomHeight: CGFloat = 10
     
    /// 列的宽度
    private var cloumnWidth: CGFloat = 10
    
    /// 盘子数量
    private var plateCount: Int = 3
    
    /// 盘子高度
    private var plateHeight: CGFloat = 10

    /// 盘子最小宽度
    private var plateMinWidth: CGFloat = 40
    
    /// 动画时间
    private var animationDuration: TimeInterval = 0.5
    
    /// 动画完成
    private var animationComplete: (() -> Void)?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor

        bottomLine.backgroundColor = .black
        bottomLine.layer.cornerRadius = 5
        bottomLine.layer.masksToBounds = true
        addSubview(bottomLine)

        leftCloumn.backgroundColor = .black
        leftCloumn.layer.cornerRadius = 5
        leftCloumn.layer.masksToBounds = true
        addSubview(leftCloumn)

        centerCloumn.backgroundColor = .black
        centerCloumn.layer.cornerRadius = 5
        centerCloumn.layer.masksToBounds = true
        addSubview(centerCloumn)

        rightCloumn.backgroundColor = .black
        rightCloumn.layer.cornerRadius = 5
        rightCloumn.layer.masksToBounds = true
        addSubview(rightCloumn)

        createPlates()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let width = bounds.width
        let height = bounds.height

        bottomLine.bounds = CGRect(x: 0, y: 0, width: width, height: bottomHeight)
        bottomLine.center = CGPoint(x: width / 2, y: height - bottomHeight)

        leftCloumn.bounds = CGRect(x: 0, y: 0, width: cloumnWidth, height: height - bottomHeight*2)
        leftCloumn.center = CGPoint(x: width / 6, y: height / 2)

        centerCloumn.bounds = leftCloumn.bounds
        centerCloumn.center = CGPoint(x: width / 2, y: height / 2)

        rightCloumn.bounds = leftCloumn.bounds
        rightCloumn.center = CGPoint(x: width / 6 * 5, y: height / 2)

        layoutTower(tower: leftCloumn)
        layoutTower(tower: centerCloumn)
        layoutTower(tower: rightCloumn)
    }

    private func layoutTower(tower: TowerCloumn) {
        for i in 0 ..< tower.plates.count {
            let plate = tower.plates[i]
            plate.center = CGPoint(x: tower.center.x, y: bottomLine.frame.minY - plateHeight * (CGFloat(i) + 0.5))
        }
    }

    /// 清理盘子
    private func clearAllPlates() {
        leftCloumn.clearPlates()
        centerCloumn.clearPlates()
        rightCloumn.clearPlates()
    }

    /// 创建盘子
    private func createPlates() {
        var plates: [Plate] = []
        for i in 0 ..< plateCount {
            let plate = Plate()
            plate.bounds = CGRect(x: 0, y: 0, width: plateMinWidth + plateHeight * CGFloat(i), height: plateHeight)
            plates.append(plate)
            addSubview(plate)
        }
        leftCloumn.plates = plates.reversed()
    }

    /// 结束位置
    private func endPoint(tower: TowerCloumn) -> CGPoint {
        var y: CGFloat = 0
        if let plate = tower.plates.last {
            y = plate.frame.minY - plate.bounds.height / 2
        } else {
            y = bottomLine.frame.minY - plateHeight / 2
        }
        return CGPoint(x: tower.center.x, y: y)
    }
}

extension TowerView: CAAnimationDelegate {
    
    /// 动画
    private func moveAnimation(plate: Plate, points: [CGPoint], complete: (() -> Void)?) {
        self.animationComplete = complete
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position"
        animation.values = points.map{ NSValue(cgPoint: $0) }
        animation.duration = animationDuration
        animation.isRemovedOnCompletion = true
        animation.delegate = self
        plate.layer.add(animation, forKey: nil)
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        self.animationComplete?()
        self.animationComplete = nil
    }
}

private extension TowerView {

    func hanoi(n: Int, a: Int, b: Int, c: Int) {
        if n == 1 {
            move(a: a, c: c)
        } else {
            hanoi(n: n - 1, a: a, b: c, c: b)
            move(a: a, c: c)
            hanoi(n: n - 1, a: b, b: a, c: c)
        }
    }

    func move(a: Int, c: Int) {
        let sema = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            self.layoutIfNeeded()
            let towers = [self.leftCloumn, self.centerCloumn, self.rightCloumn]
            let tower1 = towers[a]
            let tower2 = towers[c]
            guard let plate = tower1.plates.last else { return }
            let startPoint = plate.center
            let endPoint = self.endPoint(tower: tower2)
            tower1.remove(plate: plate)
            tower2.add(plate: plate)            
            self.moveAnimation(plate: plate, points: [startPoint, endPoint]) { [weak self] in
                guard let `self` = self else { return }
                plate.center = endPoint
                self.setNeedsLayout()
                sema.signal()
            }
        }
        sema.wait()
    }
}

extension TowerView {

    /// 重置
    func reset() {
        clearAllPlates()
        createPlates()
        setNeedsLayout()
    }

    /// 设置层数
    func set(plateCount: Int) {
        self.plateCount = plateCount
        reset()
    }

    /// 开始自动运行
    func startAutoRun() {
        reset()
        DispatchQueue.global().async {
            self.hanoi(n: self.plateCount, a: 0, b: 1, c: 2)
        }
    }
}
