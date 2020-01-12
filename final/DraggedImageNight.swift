//
//  DragImageView.swift
//  final
//
//  Created by vg19aaf on 16/12/2019.
//  Copyright © 2019 vg19aaf. All rights reserved.
//

import UIKit

class DraggedImageNight: UIImageView {
    
    var myDelegate: subViewDelegate?
    var startLocation: CGPoint?
    var currentLocation: CGPoint?
    let W = UIScreen.main.bounds.width
    let H = UIScreen.main.bounds.height
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startLocation = touches.first?.location(in: self)
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        currentLocation = touches.first?.location(in: self)
         self.myDelegate?.updateAngle(x: currentLocation!.x, y: currentLocation!.y)
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var newCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        //Constrain the movement
        
        let halfx = self.bounds.midX
        let halfy = self.bounds.midY
        //let screenWidth = self.superview!.bounds.width
        let screenHeight = self.superview!.bounds.height
        
        let minimumX = halfx
        let minimumY = (screenHeight/2) - (H/2) + (halfy)
        let maximumX = (W*0.35) - halfx
        let maximumY = (screenHeight/2) + (H/2) - halfy
        
        newCenter.x = max(minimumX,newCenter.x)
        newCenter.x = min(maximumX, newCenter.x)
        
        
        newCenter.y = max(minimumY, newCenter.y)
        newCenter.y = min(maximumY, newCenter.y)
        
        currentLocation!.x = newCenter.x
        currentLocation!.y = newCenter.y
        self.center = newCenter
       

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let dx = currentLocation!.x - startLocation!.x
        let dy = currentLocation!.y - startLocation!.y
        var initialCenter = CGPoint(x: self.center.x+dx, y: self.center.y+dy)
        
        
        let halfx = self.bounds.midX
        let halfy = self.bounds.midY
        //let screenWidth = self.superview!.bounds.width
        let screenHeight = self.superview!.bounds.height
        
        let minimumX = halfx
        let minimumY = (screenHeight/2) - (H/2) + (halfy)
        let maximumX = (W*0.35) - halfx
        let maximumY = (screenHeight/2) + (H/2) - halfy
        
        initialCenter.x = (minimumX + maximumX)/2
        initialCenter.y = (minimumY + maximumY)/2
        
        self.center = initialCenter
       
        self.myDelegate?.changeSomething()
    }
}

