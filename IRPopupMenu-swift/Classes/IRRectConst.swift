//
//  IRRectConst.swift
//  IRPopupMenu-swift
//
//  Created by Phil on 2021/2/22.
//

import Foundation
import UIKit

@inlinable func IRRectWidth(rect: CGRect) -> CGFloat {
    return rect.width;
}

@inlinable func IRRectHeight(rect: CGRect) -> CGFloat {
    return rect.height;
}

@inlinable func IRRectX(rect: CGRect) -> CGFloat {
    return rect.minX;
}

@inlinable func IRRectY(rect: CGRect) -> CGFloat {
    return rect.minY;
}

@inlinable func IRRectTop(rect: CGRect) -> CGFloat {
    return rect.minY;
}

@inlinable func IRRectBottom(rect: CGRect) -> CGFloat {
    return rect.maxY;
}
