//
//  ViewController.swift
//  Core Graphics
//
//  Created by Michele Galvagno on 09/05/2019.
//  Copyright © 2019 Michele Galvagno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawRectangle()
    }

    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 6 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
            
        case 1:
            drawCircle()
            
        case 2:
            drawCheckerboard()
            
        case 3:
            drawRotatedSquares()
            
        case 4:
            drawLines()
            
        case 5:
            drawImagesAndText()
            
        case 6:
            drawEmoji()
            
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512)) // points, not pixels!
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // centered on the size: 5 points inside and 5 points outside
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10) // centered on the size: 5 points inside and 5 points outside
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
    
    func drawCheckerboard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col).isMultiple(of: 2) { // Genius!
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        
        imageView.image = image
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256) // draw from the center of the canvas
            
            var first = true // this is the first line we are drawing
            var length: CGFloat = 256
            let y: CGFloat = 50
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: y))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: y))
                }
                
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = image
    }
    
    func drawImagesAndText() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            let string = "The best-laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        
        imageView.image = image
    }
    
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let image = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 192, y: 192)
            
            // chosen emoji 😀
            // Step 1: draw the contour
            let ellipseSize: CGFloat = 128
            let rectangle = CGRect(x: 0, y: 0, width: ellipseSize, height: ellipseSize)
            
            ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 248 / 255, green: 213 / 255, blue: 84 / 255, alpha: 1).cgColor)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // Step 2: create two rectangles to hold the eyes ellipses
            let eyesY: CGFloat = ellipseSize / 4
            let eyesWidth: CGFloat = 10
            let eyesHeight: CGFloat = 20
            let eyesRectangleLeft = CGRect(x: (ellipseSize / 2) - (15 + eyesWidth), y: eyesY, width: eyesWidth, height: eyesHeight)
            let eyesRectangleRight = CGRect(x: (ellipseSize / 2) + 15, y: eyesY, width: 10, height: 20)
            
            ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 101 / 255, green: 56 / 255, blue: 18 / 255, alpha: 1).cgColor)
            
            ctx.cgContext.addEllipse(in: eyesRectangleLeft)
            ctx.cgContext.addEllipse(in: eyesRectangleRight)
            ctx.cgContext.drawPath(using: .fillStroke)
            
            // at this point we are here: 😶, not bad at all! Now how to get to the smile?
            ctx.cgContext.beginPath()
            
            let smileX: CGFloat = 24
            let smileY: CGFloat = 86
            ctx.cgContext.move(to: CGPoint(x: smileX, y: smileY))
            
            ctx.cgContext.addQuadCurve(to: CGPoint(x: smileX + 80, y: smileY), control: CGPoint(x: 64, y: smileY + 45))
            ctx.cgContext.closePath()
            ctx.cgContext.setFillColor(UIColor.init(displayP3Red: 158/255, green: 106/255, blue: 37/155, alpha: 1).cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = image
    }
}

