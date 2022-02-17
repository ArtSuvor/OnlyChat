//
//  UIScrollView + Ext.swift
//  OnlyChat
//
//  Created by Art on 17.02.2022.
//

import UIKit

extension UIScrollView {
    var isAtBottom: Bool {
        contentOffset.y >= verticalOffsetForBottom
    }
    
    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }
}
