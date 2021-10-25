//
//  IRPopupMenuPath.swift
//  IRPopupMenu-swift
//
//  Created by Phil on 2021/2/22.
//

import Foundation
import UIKit

open class IRPopupMenuPath {
    
    public enum IRPopupMenuArrowDirection {
        case IRPopupMenuArrowDirectionTop
        case IRPopupMenuArrowDirectionBottom
        case IRPopupMenuArrowDirectionLeft
        case IRPopupMenuArrowDirectionRight
        case IRPopupMenuArrowDirectionCircle
        case IRPopupMenuArrowDirectionNone
    };
    
    class func generateBezierPath(withRect rect: CGRect, rectCorner: UIRectCorner, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor?, backgroundColor: UIColor?, arrowWidth: CGFloat, arrowHeight: CGFloat, arrowPosition: CGFloat, arrowDirection: IRPopupMenuArrowDirection) -> UIBezierPath {
        
        var rect = rect
        var arrowPosition = arrowPosition
        let bezierPath = UIBezierPath()
        if let borderColor = borderColor {
            borderColor.setStroke()
        }
        
        if let backgroundColor = backgroundColor {
            backgroundColor.setFill()
        }
        
        bezierPath.lineWidth = borderWidth
        rect = CGRect(x: borderWidth / 2, y: borderWidth / 2, width: IRRectWidth(rect: rect) - borderWidth, height: IRRectHeight(rect: rect) - borderWidth)
        var topRightRadius: CGFloat = 0, topLeftRadius: CGFloat = 0, bottomRightRadius: CGFloat = 0, bottomLeftRadius: CGFloat = 0
        var topRightArcCenter, topLeftArcCenter, bottomRightArcCenter, bottomLeftArcCenter: CGPoint
        
        if rectCorner.contains(.topLeft) {
            topLeftRadius = cornerRadius
        }
        
        if rectCorner.contains(.topRight) {
            topRightRadius = cornerRadius
        }
        
        if rectCorner.contains(.bottomLeft) {
            bottomLeftRadius = cornerRadius
        }
        
        if rectCorner.contains(.bottomRight) {
            bottomRightRadius = cornerRadius
        }
        
        if arrowDirection == .IRPopupMenuArrowDirectionTop {
            
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: arrowHeight + topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect))
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect))
            
            if arrowPosition < topLeftRadius + arrowWidth / 2 {
                arrowPosition = topLeftRadius + arrowWidth / 2
            } else if arrowPosition > IRRectWidth(rect: rect) - topRightRadius - arrowWidth / 2 {
                arrowPosition = IRRectWidth(rect: rect) - topRightRadius - arrowWidth / 2
            }
            
            bezierPath.move(to: CGPoint(x: arrowPosition - arrowWidth / 2, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition, y: IRRectTop(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition + arrowWidth / 2, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: .pi * 3 / 2, endAngle: 2 * .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionBottom {
            
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect) - arrowHeight)
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect) - arrowHeight)
            
            if arrowPosition < bottomLeftRadius + arrowWidth / 2 {
                arrowPosition = bottomLeftRadius + arrowWidth / 2
            } else if arrowPosition > IRRectWidth(rect: rect) - bottomRightRadius - arrowWidth / 2 {
                arrowPosition = IRRectWidth(rect: rect) - bottomRightRadius - arrowWidth / 2
            }
            
            bezierPath.move(to: CGPoint(x: arrowPosition + arrowWidth / 2, y: IRRectHeight(rect: rect) - arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition, y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition - arrowWidth / 2, y: IRRectHeight(rect: rect) - arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - arrowHeight + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect) - arrowHeight))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionLeft {
        
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect) + arrowHeight, y: topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect) + arrowHeight, y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect))
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect))
            
            if arrowPosition < topLeftRadius + arrowWidth / 2 {
                arrowPosition = topLeftRadius + arrowWidth / 2
            } else if arrowPosition > IRRectHeight(rect: rect) - bottomLeftRadius - arrowWidth / 2 {
                arrowPosition = IRRectHeight(rect: rect) - bottomLeftRadius - arrowWidth / 2
            }
            
            bezierPath.move(to: CGPoint(x: arrowHeight + IRRectX(rect: rect), y: arrowPosition + arrowWidth / 2))
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: arrowPosition))
            bezierPath.addLine(to: CGPoint(x: arrowHeight + IRRectX(rect: rect), y: arrowPosition - arrowWidth / 2))
            bezierPath.addLine(to: CGPoint(x: arrowHeight + IRRectX(rect: rect), y: topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius, y: IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: arrowHeight + bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionRight {
        
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect) - arrowHeight, y: topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect))
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect) - arrowHeight, y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect))
            
            if arrowPosition < topRightRadius + arrowWidth / 2 {
                arrowPosition = topRightRadius + arrowWidth / 2
            } else if arrowPosition > IRRectHeight(rect: rect) - bottomRightRadius - arrowWidth / 2 {
                arrowPosition = IRRectHeight(rect: rect) - bottomRightRadius - arrowWidth / 2
            }
            
            bezierPath.move(to: CGPoint(x: IRRectWidth(rect: rect) - arrowHeight + IRRectX(rect: rect), y: arrowPosition - arrowWidth / 2))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: arrowPosition))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - arrowHeight + IRRectX(rect: rect), y: arrowPosition + arrowWidth / 2))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - arrowHeight + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect) - arrowHeight, y: IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionNone {
        
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect))
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect))
            
            bezierPath.move(to: CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius, y: IRRectX(rect: rect)))
            
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
            
        } else if arrowDirection == .IRPopupMenuArrowDirectionCircle {
        
            topLeftArcCenter = CGPoint(x: topLeftRadius + IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect))
            topRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - topRightRadius + IRRectX(rect: rect), y: arrowHeight + topRightRadius + IRRectX(rect: rect))
            bottomLeftArcCenter = CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomLeftRadius + IRRectX(rect: rect))
            bottomRightArcCenter = CGPoint(x: IRRectWidth(rect: rect) - bottomRightRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius + IRRectX(rect: rect))
            
            if arrowPosition < topLeftRadius + arrowWidth / 2 {
                arrowPosition = topLeftRadius + arrowWidth / 2
            } else if arrowPosition > IRRectWidth(rect: rect) - topRightRadius - arrowWidth / 2 {
                arrowPosition = IRRectWidth(rect: rect) - topRightRadius - arrowWidth / 2
            }
            
            bezierPath.move(to: CGPoint(x: arrowPosition - arrowWidth / 2, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition, y: IRRectTop(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: arrowPosition + arrowWidth / 2, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) - topRightRadius, y: arrowHeight + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topRightArcCenter, radius: topRightRadius, startAngle: .pi * 3 / 2, endAngle: .pi * 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectWidth(rect: rect) + IRRectX(rect: rect), y: IRRectHeight(rect: rect) - bottomRightRadius - IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomRightArcCenter, radius: bottomRightRadius, startAngle: 0, endAngle: .pi / 2, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: bottomLeftRadius + IRRectX(rect: rect), y: IRRectHeight(rect: rect) + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: bottomLeftArcCenter, radius: bottomLeftRadius, startAngle: .pi / 2, endAngle: .pi, clockwise: true)
            bezierPath.addLine(to: CGPoint(x: IRRectX(rect: rect), y: arrowHeight + topLeftRadius + IRRectX(rect: rect)))
            bezierPath.addArc(withCenter: topLeftArcCenter, radius: topLeftRadius, startAngle: .pi, endAngle: .pi * 3 / 2, clockwise: true)
        }
        
        bezierPath.close()
        NSLog(bezierPath.bounds.debugDescription)
        return bezierPath
    }
    
    
    
    class func generateMaskLayer(rect: CGRect, rectCorner: UIRectCorner, cornerRadius: CGFloat, arrowWidth: CGFloat, arrowHeight: CGFloat, arrowPosition: CGFloat, arrowDirection: IRPopupMenuArrowDirection) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = generateBezierPath(withRect: rect, rectCorner: rectCorner, cornerRadius: cornerRadius, borderWidth: 0, borderColor: nil, backgroundColor: nil, arrowWidth: arrowWidth, arrowHeight: arrowHeight, arrowPosition: arrowPosition, arrowDirection: arrowDirection).cgPath
        return shapeLayer;
    }
    
    
}
