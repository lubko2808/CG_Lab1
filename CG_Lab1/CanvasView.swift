//
//  CanvasView.swift
//  CG_Lab1
//
//  Created by Lubomyr Chorniak on 18.02.2024.
//

import UIKit

class CanvasView: UIView {
    
    enum Constants {
        static let rectLineWidth: CGFloat = 4
        static let CoordinateLineWidth: CGFloat = 3
        static let distanceBetweenMarkings: CGFloat = 30
    }
    
    private var canvasWidth: CGFloat {
        bounds.width
    }
    
    private var canvasHeight: CGFloat {
        bounds.height
    }
    
    private let markWidth: CGFloat = 2
    private let markHeight: CGFloat = 20
    
    private let attributes: [NSAttributedString.Key: Any] = [
         .font: UIFont.systemFont(ofSize: 14),
         .foregroundColor: UIColor.black
     ]
    
    func textSize(text: String) -> CGSize {
        text.size(withAttributes: attributes)
    }
    
    var upperLeftCorner: CGPoint? = nil
    var lowerRightCorner: CGPoint? = nil
    
    private var rectWidth: CGFloat? {
        if let lowerRightCorner, let upperLeftCorner {
            return lowerRightCorner.x - upperLeftCorner.x
        }
        return nil
    }
    
    private var rectHeight: CGFloat? {
        if let lowerRightCorner, let upperLeftCorner {
            return lowerRightCorner.y - upperLeftCorner.y
        }
        return nil
    }
    
    private var circleRadius: CGFloat? {
        if let rectWidth, let rectHeight {
            return sqrt(pow(rectWidth / 2, 2) + pow(rectHeight / 2, 2)) + sqrt(pow(Constants.rectLineWidth / 2, 2) + pow(Constants.rectLineWidth / 2, 2))
        }
        return nil
    }
    
    private var circleCenter: CGPoint? {
        if let rectWidth, let rectHeight, let upperLeftCorner {
            return CGPoint(x: upperLeftCorner.x + rectWidth / 2 , y: upperLeftCorner.y + rectHeight / 2)
        }
        return nil
    }
    
    struct RectAndCircle {
        let rectPath: CGPath
        let triangle1: CGPath
        let triangle2: CGPath
        let diagonalPath: CGPath
        let circlePath: CGPath
        
        let diagonalColor: CGColor
        let triangle1Color: CGColor
        let triangle2Color: CGColor
    }
    
    private var rects: [RectAndCircle] = []
    
    var selectedColor = UIColor.red
    
    private var context: CGContext? = nil
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }
        self.context = context
        
        drawCoordinateSystem(context)
        drawMarking(context)

        drawPreviosRectangles()
        if self.upperLeftCorner != nil && self.lowerRightCorner != nil {
            drawRectangle()
        }
        drawRectangle()
    }
    
    
    private func drawPreviosRectangles() {
        guard let context else { return }
        for rect in rects {
            context.setStrokeColor(UIColor.blue.cgColor)
            context.setLineWidth(4)
            context.addPath(rect.rectPath)
            context.drawPath(using: .stroke)
            
            context.setFillColor(rect.triangle1Color)
            context.addPath(rect.triangle1)
            context.drawPath(using: .fill)
            context.setFillColor(rect.triangle2Color)
            context.addPath(rect.triangle2)
            context.drawPath(using: .fill)
            
            context.setStrokeColor(rect.diagonalColor)
            context.addPath(rect.diagonalPath)
            context.drawPath(using: .stroke)
            
            context.setLineWidth(1)
            context.setStrokeColor(UIColor.black.cgColor)
            context.addPath(rect.circlePath)
            context.drawPath(using: .stroke)
            
        }
        
    }

    private func drawRectangle() {
        guard let lowerRightCorner, let upperLeftCorner, let circleRadius, let circleCenter, let context else {
            return
        }

        let rectPath = CGMutablePath()
        rectPath.move(to: upperLeftCorner)
        rectPath.addLine(to: CGPoint(x: lowerRightCorner.x, y: upperLeftCorner.y))
        rectPath.addLine(to: lowerRightCorner)
        rectPath.addLine(to: CGPoint(x: upperLeftCorner.x, y: lowerRightCorner.y))
        rectPath.closeSubpath()
        
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(Constants.rectLineWidth)
        context.addPath(rectPath)
        context.drawPath(using: .stroke)
        
        let triangle1 = CGMutablePath()
        triangle1.move(to: upperLeftCorner)
        triangle1.addLine(to: lowerRightCorner)
        triangle1.addLine(to: CGPoint(x: upperLeftCorner.x, y: lowerRightCorner.y))
        triangle1.closeSubpath()
        
        let triangle2 = CGMutablePath()
        triangle2.move(to: upperLeftCorner)
        triangle2.addLine(to: lowerRightCorner)
        triangle2.addLine(to: CGPoint(x: lowerRightCorner.x, y: upperLeftCorner.y))
        triangle2.closeSubpath()
        
        let triangle1Color = UIColor.randomColor()
        context.setFillColor(triangle1Color)
        context.addPath(triangle1)
        context.drawPath(using: .fill)
        
        let triangle2Color = UIColor.randomColor()
        context.setFillColor(triangle2Color)
        context.addPath(triangle2)
        context.drawPath(using: .fill)
        
        let diagonalPath = CGMutablePath()
        diagonalPath.move(to: upperLeftCorner)
        diagonalPath.addLine(to: lowerRightCorner)
        
        context.setStrokeColor(selectedColor.cgColor)
        context.addPath(diagonalPath)
        context.drawPath(using: .stroke)
        
        
        let circlePath = CGMutablePath()
        circlePath.addArc(
            center: circleCenter,
            radius: circleRadius,
            startAngle: 0,
            endAngle: CGFloat.pi * 2,
            clockwise: true)
        
        context.setLineWidth(1)
        context.setStrokeColor(UIColor.black.cgColor)
        context.addPath(circlePath)
        context.drawPath(using: .stroke)

        let rect = RectAndCircle(
            rectPath: rectPath,
            triangle1: triangle1,
            triangle2: triangle2,
            diagonalPath: diagonalPath,
            circlePath: circlePath,
            diagonalColor: selectedColor.cgColor,
            triangle1Color: triangle1Color,
            triangle2Color: triangle2Color
            )
        rects.append(rect)
    }
    
    
    private func drawCoordinateSystem(_ context: CGContext) {
        
        let coordinateSystemPath = UIBezierPath()
        
        coordinateSystemPath.move(to: CGPoint(
            x: 0,
            y: canvasHeight / 2))
        
        coordinateSystemPath.addLine(to: CGPoint(
            x: canvasWidth,
            y: canvasHeight / 2))
        
        coordinateSystemPath.move(to: CGPoint(
            x: canvasWidth / 2,
            y: 0))
        
        coordinateSystemPath.addLine(to: CGPoint(
            x: canvasWidth / 2,
            y: canvasHeight))
        
        let xPointerPath = UIBezierPath()
        xPointerPath.move(to: CGPoint(
            x: canvasWidth,
            y: canvasHeight / 2))
        
        xPointerPath.addLine(to: CGPoint(
            x: canvasWidth - 20,
            y: (canvasHeight / 2) + 10))
        
        xPointerPath.addLine(to: CGPoint(
            x: canvasWidth - 20,
            y: (canvasHeight / 2) - 10))
        
        xPointerPath.close()
        
        let yPointerPath = UIBezierPath()
        yPointerPath.move(to: CGPoint(
            x: canvasWidth / 2,
            y: 0))
        
        yPointerPath.addLine(to: CGPoint(
            x: (canvasWidth / 2) - 10,
            y: 20))
        
        yPointerPath.addLine(to: CGPoint(
            x: (canvasWidth / 2) + 10,
            y: 20))

        context.setFillColor(UIColor.blue.cgColor)
        context.setStrokeColor(UIColor.blue.cgColor)
        
        context.addPath(coordinateSystemPath.cgPath)
        context.setLineWidth(Constants.CoordinateLineWidth)
        context.strokePath()

        context.addPath(xPointerPath.cgPath)
        context.fillPath()
        
        context.addPath(yPointerPath.cgPath)
        context.fillPath()
    }
    
    private func drawMarking(isAxisPositive: Bool, isXAxis: Bool ,marksCount: Int, initialX: CGFloat, initialY: CGFloat, _ context: CGContext) {
        var x = initialX
        var y = initialY
        let inset: CGFloat = 5
        for index in 0..<marksCount {
            defer {
                switch (isAxisPositive, isXAxis) {
                case (true, true):
                    x += Constants.distanceBetweenMarkings
                case (false, false):
                    y += Constants.distanceBetweenMarkings
                case (true, false):
                    y -= Constants.distanceBetweenMarkings
                case (false, true):
                    x -= Constants.distanceBetweenMarkings
                }
            }
            
            var text: NSAttributedString
            if isAxisPositive {
                text = NSAttributedString(string: "\((index + 1) * Int(Constants.distanceBetweenMarkings))", attributes: attributes)
            } else {
                text = NSAttributedString(string: "-\((index + 1) * Int(Constants.distanceBetweenMarkings))", attributes: attributes)
            }
            let textSize = textSize(text: text.string)
            
            var textRect: CGRect
            if isXAxis {
                context.addRect(CGRect(
                    x: x - (markWidth / 2),
                    y: y - (markHeight / 2),
                    width: markWidth,
                    height: markHeight))
                
                textRect = CGRect(
                    x: x - (textSize.width / 2),
                    y: y - (markHeight / 2) - (textSize.height) - inset,
                    width: textSize.width,
                    height: textSize.height)

            } else {
                context.addRect(CGRect(
                    x: x - (markHeight / 2),
                    y: y - (markWidth / 2),
                    width: markHeight,
                    height: markWidth))
                
                textRect = CGRect(
                    x: x + (markHeight / 2) + inset,
                    y: y - (textSize.height / 2),
                    width: textSize.width,
                    height: textSize.height)

            }
            
            if index == 0 { continue }
            text.draw(in: textRect)
            
        }
    }
    
    private func drawMarking(_ context: CGContext) {
        var inset: CGFloat
        
        // positive x-axis
        var x: CGFloat = canvasWidth / 2 + Constants.distanceBetweenMarkings
        var y: CGFloat = canvasHeight / 2
        inset = 30
        var marksCount = Int( (canvasWidth / 2 - inset) / Constants.distanceBetweenMarkings)
        drawMarking(isAxisPositive: true, isXAxis: true, marksCount: marksCount, initialX: x, initialY: y, context)
        
        // positive y-axis
        x = canvasWidth / 2
        y = canvasHeight / 2 - Constants.distanceBetweenMarkings
        marksCount = Int( (canvasHeight / 2 - inset) / Constants.distanceBetweenMarkings)
        drawMarking(isAxisPositive: true, isXAxis: false, marksCount: marksCount, initialX: x, initialY: y, context)
        
        // negative x-axis
        x = canvasWidth / 2 - Constants.distanceBetweenMarkings
        y = canvasHeight / 2
        inset = 10
        marksCount = Int( (canvasWidth / 2 - inset) / Constants.distanceBetweenMarkings)
        drawMarking(isAxisPositive: false, isXAxis: true, marksCount: marksCount, initialX: x, initialY: y, context)
        
        // negative y-axis
        x = canvasWidth / 2
        y = canvasHeight / 2 + Constants.distanceBetweenMarkings
        marksCount = Int( (canvasHeight / 2 - inset) / Constants.distanceBetweenMarkings)
        drawMarking(isAxisPositive: false, isXAxis: false, marksCount: marksCount, initialX: x, initialY: y, context)
        
        context.fillPath()
        
    }
    
}

extension UIColor {
    
    static func randomColor() -> CGColor {
        let red = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue = CGFloat.random(in: 0...255)
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1).cgColor
    }
    
}
