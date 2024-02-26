//
//  ViewController.swift
//  CG_Lab1
//
//  Created by Lubomyr Chorniak on 18.02.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: CanvasView!
    
    @IBOutlet weak var upperLeftXTextField: UITextField!
    
    @IBOutlet weak var upperLeftYTextField: UITextField!
    
    @IBOutlet weak var lowerRightXTextField: UITextField!
    
    @IBOutlet weak var lowerRightYTextField: UITextField!
    
    @IBOutlet weak var colorWell: UIColorWell!
    
    private var selectedColor: UIColor?
    
    @IBAction func okButtonTapped(_ sender: Any) {
        
        let canvasWidth = canvasView.bounds.width
        let canvasHeight = canvasView.bounds.height
        
        guard
            let upperLeftX = upperLeftXTextField.text,
            let upperLeftY = upperLeftYTextField.text,
            let lowerRightX = lowerRightXTextField.text,
            let lowerRightY = lowerRightYTextField.text,
            let upperLeftX = Int(upperLeftX),
            let upperLeftY = Int(upperLeftY),
            let lowerRightX = Int(lowerRightX),
            let lowerRightY = Int(lowerRightY)
        else { 
            showAlert("Invalid Input")
            return
        }
         
        let userUpperLeftCorner = CGPoint(x: CGFloat(upperLeftX), y: CGFloat(upperLeftY))
        let userLowerRightCorner = CGPoint(x: CGFloat(lowerRightX), y: CGFloat(lowerRightY))
        
        
        guard userUpperLeftCorner.x < 0 && userLowerRightCorner.x < 0 && userUpperLeftCorner.y > 0 && userLowerRightCorner.y > 0 else {
            showAlert("Only the second coordinate quarter allowed")
            return
        }
        
        let CGUpperLeftCorner = CGPoint(
            x: canvasWidth / 2 + userUpperLeftCorner.x ,
            y: canvasHeight / 2 - userUpperLeftCorner.y)
        
        
        let CGLowerRightCorner = CGPoint(
            x: canvasWidth / 2 + userLowerRightCorner.x ,
            y: canvasHeight / 2 - userLowerRightCorner.y)
        
        canvasView.upperLeftCorner = CGUpperLeftCorner
        canvasView.lowerRightCorner = CGLowerRightCorner
        canvasView.selectedColor = colorWell.selectedColor ?? .black
        canvasView.setNeedsDisplay()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func showAlert(_ message: String? = nil) {
        let alertController = UIAlertController(title: "Error Happended", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        
        upperLeftXTextField.text = ""
        upperLeftYTextField.text = ""
        lowerRightXTextField.text = ""
        lowerRightYTextField.text = ""
    }

}

