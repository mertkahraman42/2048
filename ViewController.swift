//
//  ViewController.swift
//  2048
//
//  Created by Mert Kahraman on 23/08/16.
//  Copyright © 2016 Mert Kahraman. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    /// Game initialization
    let game = Game2048()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /// Render Initial View
        renderBoard()
        
        /// Swipe Gesture Recognizers
        // Right
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respond(_:)))
        swipeRight.direction = .Right
        view.addGestureRecognizer(swipeRight)
        // Down
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respond(_:)))
        swipeDown.direction = .Down
        view.addGestureRecognizer(swipeDown)
        // Left
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respond(_:)))
        swipeLeft.direction = .Left
        view.addGestureRecognizer(swipeLeft)
        // Up
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respond(_:)))
        swipeUp.direction = .Up
        view.addGestureRecognizer(swipeUp)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // This function responds to the swipe gestures
    func respond(gesture: UISwipeGestureRecognizer) {
            switch gesture.direction {
            
            case UISwipeGestureRecognizerDirection.Right:
                game.move(.Right)
            case UISwipeGestureRecognizerDirection.Down:
                game.move(.Down)
            case UISwipeGestureRecognizerDirection.Left:
                game.move(.Left)
            case UISwipeGestureRecognizerDirection.Up:
                game.move(.Up)
            default:
                break
            }
        
        renderBoard()
    }


    
    
    func renderBoard() {
        for (index,button) in tiles.enumerate() {
            updateButton(index, button: button)
        }
    }
    
    func updateButton(index: Int, button: UIButton) {
        
        // Set the title of the button or hide it if the tile's value is 0
        let tileValue = game.board[index]
        if tileValue != 0 {
            button.setTitle(String(tileValue), forState: .Normal)
        } else if tileValue == 0 {
            button.setTitle("", forState: .Normal)
        }
        
        // Set the color palette of the tile
        if let tileType = Tile(rawValue: tileValue) {
            button.backgroundColor = tileType.tileBackgroundColor
            button.setTitleColor(tileType.tileTitleColor, forState: .Normal)
        }
        
        
    }

    
    
    @IBOutlet var tiles: [UIButton]!
    
    // There are 16 tiles on the game
    
}





























