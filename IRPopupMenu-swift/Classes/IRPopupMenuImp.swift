//
//  IRPopupMenuImp.swift
//  IRPopupMenu-swift
//
//  Created by Phil on 2021/2/22.
//

import Foundation
import UIKit

let IRScreenWidth = UIScreen.main.bounds.size.width
let IRScreenHeight = UIScreen.main.bounds.size.height
let IRMainWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })

public protocol IRPopupMenuDelegate {
    func ybPopupMenuBeganDismiss(ybPopupMenu: IRPopupMenu)
    func ybPopupMenuDidDismiss(ybPopupMenu: IRPopupMenu)
    func ybPopupMenuBeganShow(ybPopupMenu: IRPopupMenu)
    func ybPopupMenuDidShow(ybPopupMenu: IRPopupMenu)
    
    func ybPopupMenu(ybPopupMenu: IRPopupMenu, didSelectedAtIndex index: NSInteger)
    func ybPopupMenu(ybPopupMenu: IRPopupMenu, cellForRowAtIndex index: NSInteger) -> UITableViewCell?
}

public extension IRPopupMenuDelegate {
    func ybPopupMenuBeganDismiss(ybPopupMenu: IRPopupMenu) {}
    func ybPopupMenuDidDismiss(ybPopupMenu: IRPopupMenu) {}
    func ybPopupMenuBeganShow(ybPopupMenu: IRPopupMenu) {}
    func ybPopupMenuDidShow(ybPopupMenu: IRPopupMenu){}
    
    func ybPopupMenu(ybPopupMenu: IRPopupMenu, didSelectedAtIndex index: NSInteger) {}
}

open class IRPopupMenu: UIView, UITableViewDelegate, UITableViewDataSource {
    public enum IRPopupMenuType {
        case IRPopupMenuTypeDefault
        case IRPopupMenuTypeDark
    }
    
    public enum IRPopupMenuPriorityDirection {
        case IRPopupMenuPriorityDirectionTop
        case IRPopupMenuPriorityDirectionBottom
        case IRPopupMenuPriorityDirectionLeft
        case IRPopupMenuPriorityDirectionRight
        case IRPopupMenuPriorityDirectionNone
    }
    
    open private(set) var titles: NSArray? {
        didSet {
            updateUI()
        }
    }
    open private(set) var images: NSArray? {
        didSet {
            updateUI()
        }
    }
    open lazy var tableView: UITableView? = getTableView()
    open var cornerRadius: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    open var rectCorner: UIRectCorner = .allCorners {
        didSet {
            updateUI()
        }
    }
    open var isShowShadow: Bool = false {
        didSet {
            self.layer.shadowOpacity = isShowShadow ? 0.5 : 0
            self.layer.shadowOffset = CGSize.init(width: 0, height: 0)
            self.layer.shadowRadius = isShowShadow ? 2.0 : 0
        }
    }
    open var showMaskView: Bool = false {
        didSet {
            menuBackView?.backgroundColor = showMaskView ? .black.withAlphaComponent(0.5) : .clear
        }
    }
    open var dismissOnSelected: Bool = false
    open var dismissOnTouchOutside: Bool = false
    open var fontSize: CGFloat = 0
    open var font: UIFont?
    open var textColor: UIColor?
    open var offset: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    open var borderWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    open var borderColor: UIColor? {
        didSet {
            updateUI()
        }
    }
    open var arrowWidth: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    open var arrowHeight: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    
    private var _arrowPosition: CGFloat = 0
    open var arrowPosition: CGFloat {
        get {
            return _arrowPosition
        }
        set(arrowPosition) {
            _arrowPosition = arrowPosition
            updateUI()
        }
    }
    
    private var _arrowDirection: IRPopupMenuPath.IRPopupMenuArrowDirection = .IRPopupMenuArrowDirectionBottom
    open var arrowDirection: IRPopupMenuPath.IRPopupMenuArrowDirection {
        get {
            return _arrowDirection
        }
        set(arrowDirection) {
            _arrowDirection = arrowDirection
            updateUI()
        }
    }
    open var priorityDirection: IRPopupMenuPriorityDirection = .IRPopupMenuPriorityDirectionTop {
        didSet {
            updateUI()
        }
    }
    open var maxVisibleCount: NSInteger = 0 {
        didSet {
            updateUI()
        }
    }
    open var backColor: UIColor? {
        didSet {
            updateUI()
        }
    }
    open var itemHeight: CGFloat = 0 {
        didSet {
            updateUI()
        }
    }
    open var minSpace: CGFloat = 0
    open var type: IRPopupMenuType = .IRPopupMenuTypeDefault {
        didSet {
            switch type {
            case .IRPopupMenuTypeDark:
                
                textColor = .lightGray
                backColor = UIColor.init(red: 0.25, green: 0.27, blue: 0.29, alpha: 1)
                separatorColor = .lightGray
                
            default:
                
                textColor = .black
                backColor = .white
                separatorColor = .lightGray
                
                break;
            }
            self.updateUI()
        }
    }
    //    open var orientationManager: IRPopupMenuDeviceOrientationManager
    //    open var animationManager: IRPopupMenuAnimationManager
    open var delegate: IRPopupMenuDelegate?
    
    private var menuBackView: UIView?
    private var relyRect: CGRect?
    private var itemWidth: CGFloat? {
        didSet {
            updateUI()
        }
    }
    private var point: CGPoint? {
        didSet {
            updateUI()
        }
    }
    private var isCornerChanged: Bool!
    private var separatorColor: UIColor?
    private var isChangeDirection: Bool?
    private var relyView: UIView?
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    convenience public init(showAtPoint point: CGPoint, titles: NSArray, icons: NSArray, menuWidth itemWidth: CGFloat, otherSettings: (_ popupMenu: IRPopupMenu) -> ()) {
        self.init()
        
        self.point = point
        self.titles = titles
        self.images = icons
        self.itemWidth = itemWidth
        otherSettings(self)
        self.show()
    }
    
    @discardableResult
    convenience public init(showRelyOnView view: UIView, titles: NSArray, icons: NSArray, menuWidth itemWidth: CGFloat, otherSettings: (_ popupMenu: IRPopupMenu) -> ()) {
        self.init()
        
        self.relyView = view
        self.titles = titles
        self.images = icons
        self.itemWidth = itemWidth
        otherSettings(self)
        self.show()
    }
    
    init() {
        super.init(frame: .zero)
        
        setDefaultSettings()
    }
    
    // MARK: - Public
    open func dismiss() {
        delegate?.ybPopupMenuBeganDismiss(ybPopupMenu: self)
        UIView.animate(withDuration: 0.25) {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.1, y: 0.1))
            self.alpha = 0
            self.menuBackView?.alpha = 0
        } completion: { finished in
            self.delegate?.ybPopupMenuDidDismiss(ybPopupMenu: self)
            self.delegate = nil
            self.removeFromSuperview()
            self.menuBackView?.removeFromSuperview()
        }

    }
    
    open class func dismissAllPopupMenu() {
        for subView in IRMainWindow!.subviews {
            if subView.isKind(of:IRPopupMenu.self) {
                let popupMenu: IRPopupMenu = subView as! IRPopupMenu
                popupMenu.dismiss()
            }
        }
    }
    
    // MARK: - DataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell: UITableViewCell?
        tableViewCell = delegate?.ybPopupMenu(ybPopupMenu: self, cellForRowAtIndex: indexPath.row)
        
        if tableViewCell != nil {
            return tableViewCell!
        }
        
        let identifier: String = "ybPopupMenu"
        var cell: IRPopupMenuCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? IRPopupMenuCell
        
        if cell == nil {
            cell = IRPopupMenuCell.init(style: .default, reuseIdentifier: identifier)
            cell?.textLabel?.numberOfLines = 0
        }
        
        cell?.backgroundColor = .clear
        cell?.textLabel?.textColor = textColor
        
        if font != nil {
            cell?.textLabel?.font = font
        } else {
            cell?.textLabel?.font = UIFont.systemFont(ofSize: fontSize)
        }
        
        if (titles?[indexPath.row] as! NSObject).isKind(of: NSAttributedString.self) {
            cell?.textLabel?.attributedText = titles?[indexPath.row] as? NSAttributedString
        } else if (titles?[indexPath.row] as! NSObject).isKind(of: NSString.self) {
            cell?.textLabel?.text = titles?[indexPath.row] as? NSString as String?
        } else {
            cell?.textLabel?.text = nil
        }
        
        cell?.separatorColor = separatorColor
        
        if images?.count ?? 0 >= indexPath.row + 1 {
            if (images?[indexPath.row] as! NSObject).isKind(of: NSString.self) {
                cell?.imageView?.image = UIImage.init(named: images?[indexPath.row] as! NSString as String)
            } else if (images?[indexPath.row] as! NSObject).isKind(of: UIImage.self) {
                cell?.imageView?.image = images?[indexPath.row] as? UIImage
            } else {
                cell?.imageView?.image = nil
            }
        } else {
            cell?.imageView?.image = nil
        }
        
        return cell!
    }
    
    // MARK: - TableViewDelegate
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (dismissOnSelected) {
            self.dismiss()
        }
        
        delegate?.ybPopupMenu(ybPopupMenu: self, didSelectedAtIndex: indexPath.row)
    }
    
    // MARK: - ScrollViewDelegate
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.getLastVisibleCell().isKind(of: IRPopupMenuCell.self) {
            let cell = self.getLastVisibleCell() as! IRPopupMenuCell
            cell.isShowSeparator = true
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.getLastVisibleCell().isKind(of: IRPopupMenuCell.self) {
            let cell = self.getLastVisibleCell() as! IRPopupMenuCell
            cell.isShowSeparator = false
        }
    }
    
    func getLastVisibleCell() -> UITableViewCell {
        var indexPaths = self.tableView?.indexPathsForVisibleRows
        indexPaths = indexPaths?.sorted(by: { obj1, obj2 in
            obj1.row < obj2.row
        })
        guard let indexPath = indexPaths?.first else {
            return IRPopupMenuCell.init()
        }
        return self.tableView?.cellForRow(at: indexPath) ?? UITableViewCell()
    }
    
    // MARK: - Private
    private func setDefaultSettings() {
        cornerRadius = 5.0;
        rectCorner = .allCorners
        self.isShowShadow = true
        dismissOnSelected = true
        dismissOnTouchOutside = true
        fontSize = 15;
        textColor = .black
        offset = 0.0;
        relyRect = .zero
        point = .zero
        borderWidth = 0.0;
        borderColor = .lightGray
        arrowWidth = 15.0
        arrowHeight = 10.0
        backColor = .white
        type = .IRPopupMenuTypeDefault
        arrowDirection = .IRPopupMenuArrowDirectionTop
        priorityDirection = .IRPopupMenuPriorityDirectionTop
        minSpace = 10.0;
        maxVisibleCount = 5;
        itemHeight = 44;
        isCornerChanged = false
        showMaskView = true
        menuBackView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: IRScreenWidth, height: IRScreenHeight))
        menuBackView?.backgroundColor = .black.withAlphaComponent(0.5)
        menuBackView?.alpha = 0
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(touchOutSide))
        menuBackView?.addGestureRecognizer(tap)
        self.alpha = 0
        self.backgroundColor = .clear
        self.addSubview(tableView!)
    }
    
    private func show() {
        IRMainWindow?.addSubview(menuBackView!)
        IRMainWindow?.addSubview(self)
        
        if self.getLastVisibleCell().isKind(of: IRPopupMenuCell.self) {
            let cell = self.getLastVisibleCell() as! IRPopupMenuCell
            cell.isShowSeparator = false
        }
        
        self.delegate?.ybPopupMenuBeganShow(ybPopupMenu: self)
        self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 0.1, y: 0.1))
        UIView.animate(withDuration: 0.25) {
            self.layer.setAffineTransform(CGAffineTransform.init(scaleX: 1.0, y: 1.0))
            self.alpha = 1
            self.menuBackView?.alpha = 1
        } completion: { finished in
            self.delegate?.ybPopupMenuDidShow(ybPopupMenu: self)
        }
    }
    
    private func getTableView() -> UITableView {
        tableView = UITableView.init(frame: .zero, style: .plain)
        tableView?.backgroundColor = .clear
        tableView?.tableFooterView = UIView.init()
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.separatorStyle = .none
        return tableView!
    }
    
    @objc
    private func touchOutSide() {
        if dismissOnTouchOutside {
            self.dismiss()
        }
    }
    
    private func updateUI() {
        var height = 0.0
        if let count = titles?.count, count > maxVisibleCount {
            height = itemHeight * CGFloat(count) + borderWidth * 2
            self.tableView?.bounces = true
        } else {
            height = itemHeight * CGFloat(titles?.count ?? 0) + borderWidth * 2
            self.tableView?.bounces = false
        }
        
        isChangeDirection = false
        var isChangeDirection = isChangeDirection!
        let point = point ?? CGPoint.zero
        let itemWidth = itemWidth ?? 0
        
        if priorityDirection == .IRPopupMenuPriorityDirectionTop {
            if point.y + height + arrowHeight > IRScreenHeight - minSpace {
                _arrowDirection = .IRPopupMenuArrowDirectionBottom
                isChangeDirection = true
            } else {
                _arrowDirection = .IRPopupMenuArrowDirectionTop
                isChangeDirection = false
            }
        } else if priorityDirection == .IRPopupMenuPriorityDirectionBottom {
            if point.y - height - arrowHeight < minSpace {
                _arrowDirection = .IRPopupMenuArrowDirectionTop
                isChangeDirection = true
            } else {
                _arrowDirection = .IRPopupMenuArrowDirectionBottom
                isChangeDirection = false
            }
        } else if priorityDirection == .IRPopupMenuPriorityDirectionLeft {
            if point.x + itemWidth + arrowHeight > IRScreenWidth - minSpace {
                _arrowDirection = .IRPopupMenuArrowDirectionRight
                isChangeDirection = true
            } else {
                _arrowDirection = .IRPopupMenuArrowDirectionLeft
                isChangeDirection = false
            }
        } else if priorityDirection == .IRPopupMenuPriorityDirectionLeft {
            if point.x - itemWidth - arrowHeight < minSpace {
                _arrowDirection = .IRPopupMenuArrowDirectionLeft
                isChangeDirection = true
            } else {
                _arrowDirection = .IRPopupMenuArrowDirectionRight
                isChangeDirection = false
            }
        }
        
        setArrowPosition()
        setRelyRect()
        
        if arrowDirection == .IRPopupMenuArrowDirectionTop {
            let y = point.y
            if arrowPosition > itemWidth / 2 {
                self.frame = CGRect(x: IRScreenWidth - minSpace - itemWidth, y: y, width: itemWidth, height: height + arrowHeight)
            } else if arrowPosition < itemWidth / 2 {
                self.frame = CGRect(x: minSpace, y: y, width: itemWidth, height: height + arrowHeight)
            } else {
                self.frame = CGRect(x: (point.x) - itemWidth / 2, y: y, width: itemWidth, height: height + arrowHeight)
            }
        } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
            let y = isChangeDirection ? point.y - arrowHeight - height : point.y - arrowHeight - height;
            if arrowPosition > itemWidth / 2 {
                self.frame = CGRect(x: IRScreenWidth - minSpace - itemWidth, y: y, width: itemWidth, height: height + arrowHeight)
            } else if arrowPosition < itemWidth / 2 {
                self.frame = CGRect(x: minSpace, y: y, width: itemWidth, height: height + arrowHeight)
            } else {
                self.frame = CGRect(x: point.x - itemWidth / 2, y: y, width: itemWidth, height: height + arrowHeight)
            }
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
            let x = isChangeDirection ? point.x : point.x
            if arrowPosition < itemHeight / 2 {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth, height: height)
            } else if arrowPosition > itemHeight / 2 {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth, height: height)
            } else {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth + arrowHeight, height: height)
            }
        } else if arrowDirection == .IRPopupMenuArrowDirectionRight {
            let x = isChangeDirection ? point.x - itemWidth - arrowHeight : point.x - itemWidth - arrowHeight
            if arrowPosition < itemHeight / 2 {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth + arrowHeight, height: height)
            } else if arrowPosition > itemHeight / 2 {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth + arrowHeight, height: height)
            } else {
                self.frame = CGRect(x: x, y: point.y - arrowPosition, width: itemWidth + arrowHeight, height: height)
            }
        } else if arrowDirection == .IRPopupMenuArrowDirectionCircle {
            let y = point.y
            self.frame = CGRect(x: point.x, y: y, width: itemWidth, height: height + arrowHeight)
        } else if arrowDirection == .IRPopupMenuArrowDirectionNone {
            let y = point.y
            self.frame = CGRect(x: point.x, y: y, width: itemWidth, height: height)
        }
        
        self.isChangeDirection = isChangeDirection
        
        if isChangeDirection {
            changeRectCorner()
        }
        
        let layer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: self.tableView?.bounds ?? CGRect.zero, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        layer.path = path.cgPath
        self.tableView?.layer.mask = layer
        
        setAnchorPoint()
        setOffset()
        tableView?.reloadData()
        self.setNeedsDisplay()
    }
    
    func setRelyRect() {
        guard let relyRect = relyRect, !relyRect.equalTo(CGRect.zero) else {
            return
        }
        
        if arrowDirection == .IRPopupMenuArrowDirectionTop {
            point?.y = relyRect.size.height + relyRect.origin.y
        } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
            point?.y = relyRect.origin.y
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
            point = CGPoint(x: relyRect.origin.x + relyRect.size.width, y: relyRect.origin.y + relyRect.size.height / 2)
        } else {
            point = CGPoint(x: relyRect.origin.x + relyRect.origin.y, y: relyRect.size.height / 2)
        }
    }
    
    open override var frame: CGRect {
        didSet {
            if arrowDirection == .IRPopupMenuArrowDirectionTop {
                tableView?.frame = CGRect(x: borderWidth, y: borderWidth + arrowHeight, width: frame.size.width - borderWidth * 2, height: frame.size.height - arrowHeight)
            } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
                tableView?.frame = CGRect(x: borderWidth, y: borderWidth, width: frame.size.width - borderWidth * 2, height: frame.size.height - arrowHeight)
            } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
                tableView?.frame = CGRect(x: borderWidth + arrowHeight, y: borderWidth, width: frame.size.width - borderWidth * 2 - arrowHeight, height: frame.size.height)
            } else if arrowDirection == .IRPopupMenuArrowDirectionRight {
                tableView?.frame = CGRect(x: borderWidth, y: borderWidth, width: frame.size.width - borderWidth * 2 - arrowHeight, height: frame.size.height)
            } else if arrowDirection == .IRPopupMenuArrowDirectionCircle {
                tableView?.frame = CGRect(x: borderWidth, y: borderWidth  + arrowHeight, width: frame.size.width - borderWidth * 2, height: frame.size.height - arrowHeight)
            } else {
                tableView?.frame = CGRect(x: borderWidth, y: borderWidth + arrowHeight, width: frame.size.width - borderWidth * 2, height: frame.size.height - arrowHeight)
            }
        }
    }
    
    func changeRectCorner() {
        if isCornerChanged || rectCorner == .allCorners {
            return;
        }
        
        var haveTopLeftCorner = false, haveTopRightCorner = false, haveBottomLeftCorner = false, haveBottomRightCorner = false
        if rectCorner.contains(.topLeft) {
            haveTopLeftCorner = true
        }
        if rectCorner.contains(.topRight) {
            haveTopRightCorner = true
        }
        if rectCorner.contains(.bottomLeft) {
            haveBottomLeftCorner = true
        }
        if rectCorner.contains(.bottomRight) {
            haveBottomRightCorner = true
        }
        
        if arrowDirection == .IRPopupMenuArrowDirectionTop || arrowDirection == .IRPopupMenuArrowDirectionBottom {
            
            if haveTopLeftCorner {
                rectCorner = rectCorner.union(.bottomLeft)
            } else {
                rectCorner = rectCorner.subtracting(.bottomLeft)
            }
            
            if haveTopRightCorner {
                rectCorner = rectCorner.union(.bottomRight)
            } else {
                rectCorner = rectCorner.subtracting(.bottomRight)
            }
            
            if haveBottomLeftCorner {
                rectCorner = rectCorner.union(.topLeft)
            } else {
                rectCorner = rectCorner.subtracting(.topLeft)
            }
            
            if haveBottomRightCorner {
                rectCorner = rectCorner.union(.topRight)
            } else {
                rectCorner = rectCorner.subtracting(.topRight)
            }
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft || arrowDirection == .IRPopupMenuArrowDirectionRight {
            
            if haveTopLeftCorner {
                rectCorner = rectCorner.union(.topRight)
            } else {
                rectCorner = rectCorner.subtracting(.topRight)
            }
            
            if haveTopRightCorner {
                rectCorner = rectCorner.union(.topLeft)
            } else {
                rectCorner = rectCorner.subtracting(.topLeft)
            }
            
            if haveBottomLeftCorner {
                rectCorner = rectCorner.union(.bottomRight)
            } else {
                rectCorner = rectCorner.subtracting(.bottomRight)
            }
            
            if haveBottomRightCorner {
                rectCorner = rectCorner.union(.bottomLeft)
            } else {
                rectCorner = rectCorner.subtracting(.bottomLeft)
            }
        }
        
        isCornerChanged = true
    }
    
    func setOffset() {
        if itemWidth == 0 {
            return
        }
        
        var originRect = self.frame
        
        if arrowDirection == .IRPopupMenuArrowDirectionTop {
            originRect.origin.y += offset
        } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
            originRect.origin.y -= offset
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
            originRect.origin.x += offset
        } else if arrowDirection == .IRPopupMenuArrowDirectionRight {
            originRect.origin.x -= offset
        } else {
            originRect.origin.y += offset
        }
        
        self.frame = originRect;
    }
    
    func setAnchorPoint() {
        guard let itemWidth = itemWidth, itemWidth != 0 else {
            return
        }
        
        var point = CGPoint(x: 0.5, y: 0.5)
        if arrowDirection == .IRPopupMenuArrowDirectionTop {
            point = CGPoint(x: arrowPosition / itemWidth, y: 0)
        } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
            point = CGPoint(x: arrowPosition / itemWidth, y: 1)
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
            point = CGPoint(x: 0, y: (itemHeight - arrowPosition) / itemHeight)
        } else if arrowDirection == .IRPopupMenuArrowDirectionRight {
            point = CGPoint(x: 1, y:  (itemHeight - arrowPosition) / itemHeight)
        }
        
        let originRect = self.frame
        self.layer.anchorPoint = point
        self.frame = originRect
    }
    
    func setArrowPosition() {
        if priorityDirection == .IRPopupMenuPriorityDirectionNone {
            return
        }
        
        let itemWidth = itemWidth ?? 0
        let point = point ?? CGPoint.zero
        if arrowDirection == .IRPopupMenuArrowDirectionTop || arrowDirection == .IRPopupMenuArrowDirectionBottom {
            if point.x + itemWidth / 2 > IRScreenWidth - minSpace {
                _arrowPosition = itemWidth - (IRScreenWidth - minSpace - point.x)
            } else if point.x < itemWidth / 2 + minSpace {
                _arrowPosition = point.x - minSpace
            } else {
                _arrowPosition = itemWidth / 2
            }
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft || arrowDirection == .IRPopupMenuArrowDirectionRight {
            //        if (_point.y + _itemHeight / 2 > IRScreenHeight - _minSpace) {
            //            _arrowPosition = _itemHeight - (IRScreenHeight - _minSpace - _point.y);
            //        }else if (_point.y < _itemHeight / 2 + _minSpace) {
            //            _arrowPosition = _point.y - _minSpace;
            //        }else {
            //            _arrowPosition = _itemHeight / 2;
            //        }
        }
    }
    
    open override func draw(_ rect: CGRect) {
        let bezierPath = IRPopupMenuPath.generateBezierPath(withRect: rect, rectCorner: rectCorner, cornerRadius: cornerRadius, borderWidth: borderWidth, borderColor: borderColor, backgroundColor: backColor, arrowWidth: arrowWidth, arrowHeight: arrowHeight, arrowPosition: arrowPosition, arrowDirection: arrowDirection)
        bezierPath.fill()
        bezierPath.stroke()
    }
    
}
