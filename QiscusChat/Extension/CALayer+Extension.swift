//
//  CALayer+Extension.swift
//  QiscusChat
//
//  Created by Willa on 23/09/20.
//  Copyright © 2020 WillaSaskara. All rights reserved.
//

import UIKit

enum CornerRadiusType{
    
    /// Half of the frame height
    case rounded
}

extension CALayer{
    
    /// Set a round corner of with layer
    /// - Parameters:
    ///   - corners: selected corner
    ///   - radius: raoius
    func roundCorners(_ corners: CACornerMask, radius: CGFloat) {
        if #available(iOS 11, *) {
            cornerRadius = radius
            maskedCorners = corners
        } else {
            var cornerMask = UIRectCorner()
            if(corners.contains(.layerMinXMinYCorner)){
                cornerMask.insert(.topLeft)
            }
            if(corners.contains(.layerMaxXMinYCorner)){
                cornerMask.insert(.topRight)
            }
            if(corners.contains(.layerMinXMaxYCorner)){
                cornerMask.insert(.bottomLeft)
            }
            if(corners.contains(.layerMaxXMaxYCorner)){
                cornerMask.insert(.bottomRight)
            }
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornerMask, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.mask = mask
        }
    }
    
    
    /// Set a round corner of with layer but with preset but only working for rounded
    /// - Parameter type: CornerRadiusType
    func roudCornerType(type: CornerRadiusType){
        switch type {
        case .rounded:
            cornerRadius = self.bounds.height / 2
        }
    }
    
}
