//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Apple on 2016/12/31.
//  Copyright © 2016年 Hans. All rights reserved.
//

import UIKit
import AVFoundation

class LaunchScreenVC: UIViewController {
    
}

class calculatorVC: UIViewController {
    
    var btnSound: AVAudioPlayer!  // audio may or may not exist
    
    @IBOutlet weak var outputLabel: UILabel!
    
    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Equal = "="
        case Empty = "Empty"
    }
    
    var runningNumber = "0"
    var leftValStr = ""
    var rightValStr = ""
    var result = ""
    var currentOperation = Operation.Empty
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav") // bundle resources for the app
        let soundURL = URL(fileURLWithPath: path!) // set up the URL for the sound
        
        do { // catch if the sound has an error
            try btnSound = AVAudioPlayer(contentsOf: soundURL) // import the sound
            btnSound.prepareToPlay() // have the sound, prepare to play
        } catch let err as NSError {
            print(err.debugDescription) // print out the error
        }
    }
    
    @IBAction func clearPressed(sender: AnyObject) {
        leftValStr = "";
        rightValStr = "";
        result = ""
        runningNumber = "0";
        currentOperation = Operation.Empty
    }
    
    @IBAction func numberPressed(sender: UIButton) { // drag this line to every number, so that whenever a number is pressed, it can call this function
        playSound()
        
        if (runningNumber == "0") {
            runningNumber = "\(sender.tag)"
        } else if (runningNumber == "" && currentOperation == Operation.Equal) {
            leftValStr = ""
            runningNumber = "\(sender.tag)"
            rightValStr = ""
            result = ""
            currentOperation = Operation.Empty
            } else {
            runningNumber += "\(sender.tag)" // get which number is pressed
        }
        outputLabel.text = runningNumber // display the number
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(operation: Operation.Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(operation: Operation.Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(operation: Operation.Subtract)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(operation: Operation.Add)
    }
    
    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(operation: Operation.Equal)
    }
    
    func playSound() {
        if btnSound.isPlaying {
            btnSound.stop()
        }
        
        btnSound.play()
    }
    
    func processOperation(operation: Operation) {
        playSound()
        if (currentOperation != Operation.Empty) { // already some operation pending, deal with current operation first
            if (runningNumber != "") {  // has finished the set the second number, now do the operation
                rightValStr = runningNumber
                runningNumber = ""
                
                // do the operation first
                if (currentOperation == Operation.Multiply) {
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                    
                } else if (currentOperation == Operation.Divide) {
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                    
                } else if (currentOperation == Operation.Subtract) {
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                    
                } else if (currentOperation == Operation.Add) {
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                }
                
                //store the result
                leftValStr = result
                outputLabel.text = result
            }
            currentOperation = operation // set the new operation
        } else { // the first operation, only set the leftVal
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = operation
            
            // um, what if user pressed an operation at the very beginning???
        }
    }

}

