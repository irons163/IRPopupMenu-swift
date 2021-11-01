//
//  IRPopupMenuCell.swift
//  IRPopupMenu-swift
//
//  Created by Phil on 2021/8/4.
//

import Foundation
import UIKit

class IRPopupMenuCell: UITableViewCell {
    static let YBScreenWidth = UIScreen.main.bounds.width
    static let YBScreenHeight = UIScreen.main.bounds.height
    static let YBMainWindow = UIApplication.shared.keyWindow
    
    var isShowSeparator: Bool {
        set {
            self.isShowSeparator = newValue
            self.setNeedsDisplay()
        }
        get {
            return self.isShowSeparator
        }
    }
    
    var separatorColor: UIColor? {
        set {
            self.separatorColor = newValue
            self.setNeedsDisplay()
        }
        get {
            return self.separatorColor
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func draw(_ rect: CGRect) {
        if !isShowSeparator {
            return
        }
        
        let bezierPath = UIBezierPath.init(rect: CGRect.init(x: 0, y: rect.size.height - 0.5, width: rect.size.width, height: 0.5))
        
        separatorColor?.setFill()
        bezierPath.fill(with: .normal, alpha: 1)
        bezierPath.close()
    }
}
