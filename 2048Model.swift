//
//  2048Model.swift
//  2048
//
//  Created by Mert Kahraman on 23/08/16.
//  Copyright © 2016 Mert Kahraman. All rights reserved.
//

import Foundation
import UIKit

protocol GameEngine {
    var direction: Direction { get set }
}


enum Direction {
    case Right
    case Down
    case Left
    case Up
}


enum Tile: Int {
    case T0 = 0
    case T2 = 2
    case T4 = 4
    case T8 = 8
    case T16 = 16
    case T32 = 32
    case T64 = 64
    case T128 = 128
    case T256 = 256
    case T512 = 512
    case T1024 = 1024
    case T2048 = 2048
    
    var tileBackgroundColor: UIColor {
        get {
            switch self {
            case T0: return UIColor(red: 194/255.0, green: 180/255.0, blue: 164/255.0, alpha: 1)
            case T2: return UIColor(red: 234/255.0, green: 222/255.0, blue: 209/255.0, alpha: 1)
            case T4: return UIColor(red: 233/255.0, green: 218/255.0, blue: 187/255.0, alpha: 1)
            case T8: return UIColor(red: 239/255.0, green: 162/255.0, blue: 97/255.0, alpha: 1)
            case T16: return UIColor(red: 241/255.0, green: 128/255.0, blue: 76/255.0, alpha: 1)
            case T32: return UIColor(red: 244/255.0, green: 101/255.0, blue: 73/255.0, alpha: 1)
            case T64: return UIColor(red: 244/255.0, green: 69/255.0, blue: 38/255.0, alpha: 1)
            case T128: return UIColor(red: 233/255.0, green: 200/255.0, blue: 88/255.0, alpha: 1)
            case T256: return UIColor(red: 238/255.0, green: 210/255.0, blue: 28/255.0, alpha: 1)
            case T512: return UIColor(red: 238/255.0, green: 209/255.0, blue: 0/255.0, alpha: 1)
            case T1024: return UIColor(red: 238/255.0, green: 189/255.0, blue: 0/255.0, alpha: 1)
            case T2048: return UIColor(red: 238/255.0, green: 96/255.0, blue: 0/255.0, alpha: 1)
            }
        }
    }
    
    var tileTitleColor: UIColor {
        get {
            switch self {
            case T2, T4: return UIColor(red: 100/255.0, green: 91/255.0, blue: 82/255.0, alpha: 1)
            default: return UIColor(red: 247/255.0, green: 244/255.0, blue: 238/255.0, alpha: 1)
            }
        }
    }
    
    
    
    
}




class Game2048: GameEngine {
    var direction: Direction = .Right
    var score: Int = 0
    var turn: Int = 0 {
        didSet {
            print("Turn #\(turn)\n")
        }
    }
    
    var isAnyTileEmpty: Bool {
        get {
            var sum = 0
            for (_,value) in board.enumerate() {
                if value == 0 {
                    sum += 1
                }
            }
            return sum > 0 ? true : false
        }
    }
    
    var board = [Int](count: 16, repeatedValue: 0)
    
    var controlBoard = [Int](count: 16, repeatedValue: 0)
    
    init() {
        board = [0,  0,  0,  0,
                 0,  0,  0,  0,
                 0,  0,  0,  0,
                 0,  0,  0,  0]
        
        print("Welcome to 2048 by Mert Kahraman.\n\nInitializing game...\nCreating board...\nBoard creation complete.\n")
        printBoardToConsole()
        
        // Spawn 2 tiles at the beginning of the game
        randomTileGenerator()
        randomTileGenerator()
        
    }
    
    
    func move(swipeDirection: Direction) {
        
        direction = swipeDirection
        print("Player swiped to \(direction)")
        if isDirectionPlayable {
            turn += 1
            sideMove(swipeDirection, isForControl: false)
            if isAnyTileEmpty {
                randomTileGenerator()
            }
            printBoardToConsole()
            isGameOver
        } else {
            print("Move not possible, please swipe to another direction")
        }
        
    }
    
    
    // TODO: Merge this variable with isGameOver
    var isDirectionPlayable: Bool {
        get {
            sideMove(direction, isForControl: true)
            if controlBoard != board {
                controlBoard = [Int](count: 16, repeatedValue: 0)
                return true
            } else {
                controlBoard = [Int](count: 16, repeatedValue: 0)
                return false
            }
        }
    }
    
    var isGameOver: Bool {
        get {
            for potentialDirection in [Direction.Left,.Right] {
                sideMove(potentialDirection, isForControl: true)
                if controlBoard != board {
                    print("\nNext turn...")
                    return false
                }
                controlBoard = [Int](count: 16, repeatedValue: 0)
            }
            print("GAME OVER")
            return true
        }
    }
    
    
    func printBoardToConsole() {
        print("Board:")
        for i in [0,4,8,12] {
            var row: [Int] = []
            for j in 0...3 {
                row.append(board[i + j])
            }
            print(row)
        }
        
    }
    
    func randomTileGenerator() {
        var randomTileIndex = 0
        var iteration = 0
        var isEmpty = false
        while isEmpty == false {
            randomTileIndex = Int(arc4random_uniform(16))
            iteration += 1
            if board[randomTileIndex] == 0 {
                isEmpty = true
            }
        }
        var tile: Int
        let twoOrFour = Int(arc4random_uniform(100))
        switch twoOrFour {
        case 0...18:
            tile = 4
            board[randomTileIndex] = tile
        default:
            tile = 2
            board[randomTileIndex] = tile
        }
        print("Random tile of \(tile) added to index#\(randomTileIndex) after \(iteration) iteration")
    }
    
    
    func sideMove(direction: Direction, isForControl: Bool) {
        let log = false
        
        // Below section arranges the direction in which the sequence of numbers will be divided into arrays of 4 elements, in order to make calculations on them
        var startingIndex = 0, indexIterationLimit = 0, iterationAmount = 0
        switch direction {
        case .Left:
            startingIndex = 0; indexIterationLimit = 4; iterationAmount = 1;
        case .Right:
            startingIndex = 3; indexIterationLimit = -1; iterationAmount = -1
        case .Up:
            startingIndex = 0; indexIterationLimit = 13; iterationAmount = 4;
        case .Down:
            startingIndex = 12; indexIterationLimit = -1; iterationAmount = -4;
        }
        
        
        // Below section arranges the initial starting point of those array of 4 elements so that it makes it way easier to the algorithm to calculate. It is written explicitly here to make the code more clarified.
        var startingNumberSequence: [Int] {
            get {
                switch direction {
                case .Left, .Right:
                    return [0,4,8,12]
                case .Up, .Down:
                    return [0,1,2,3]
                }
            }
        }
        
        
        // print("a:\(aa) b:\(bb) c:\(cc)")
        
        for baseIndex in startingNumberSequence {
            var row: [Int] = []
            for indexAddition in startingIndex.stride(to: indexIterationLimit, by: iterationAmount) { //// This is the for-loop that iterates inside four rows of four numbers. a,b and c defines the direction of where should the for in loop iterate. The directions are previously controlled thru a switch statement.
                row.append(board[baseIndex + indexAddition])
            }
            //log ? print(row) : ()
            // The following section calculates additions of same values but not slide them yet
            
            for x in 0...2 {
                if row[x] != 0 {
                    for n in (x + 1)...3 {
                        if row[n] == row[x] {
                            row[x] = 2 * row[x]
                            score += row[x]
                            row[n] = 0
                            break
                        } else if row[n] != 0 {
                            break
                        }
                    }
                }
            }
            
            //log ? print("Iteration of i=\(baseIndex), row=\(row)") : ()
            // This section slides all the resulting tiles to the side.
            // lmz refers to left most zero
            var lmz: Int? = nil
            var zeroesPassed = 0
            let sumRow = row[0] + row[1] + row[2] + row[3]
            //log ? print("sumRow is \(sumRow)") : ()
            var isIterationComplete = sumRow == 0 ? true : false
            while isIterationComplete == false {
                //log ? print("So enter the loop...") : ()
                for c in 0...3 {
                    //log ? print("for c:\(c)") : ()
                    if row[c] == 0 && lmz == nil {
                        //log ? print("Since c is 0 assign lmz to become: \(c)") : ()
                        lmz = c
                    } else if lmz != nil && row[c] != 0 {
                        //log ? print("Row[c]:\(row[c]) is not 0, and lmz:\(lmz!)\nSo update row[lmz]:\(row[c]) and row[c]:\(0) and lmz:\(c)") : ()
                        row[lmz!] = row[c]
                        row[c] = 0
                        //log ? print("zeroesPassed is \(zeroesPassed)") : ()
                        lmz = c - zeroesPassed
                        
                    } else if row[c] == 0 {
                        //log ? print("zeroesPassed is \(zeroesPassed) increasing it by 1...") : ()
                        zeroesPassed += 1
                        //log ? print("Now zeroesPassed is \(zeroesPassed)") : ()
                    }
                    //log ? print("row became:\(row)") : ()
                }
                
                
                
                // Moving tiles towards the wall
                var sum = 0
                var l = 3
                //log ? print("Now checking from right hand side to see if we're done...") : ()
                while l > 0 {
                    sum += row[l]
                    //log ? print("Sum of 0's are:\(sum)") : ()
                    if sum > 0 {
                        //log ? print("So leave the iteration with row:\(row)") : ()
                        isIterationComplete = true
                        break
                    }
                    l -= 1
                    //log ? print("l becomes: \(l)") : ()
                }
                isIterationComplete = true
                //log ? print("case: ?") : ()
            }
            
            
            //log ? print("Hence row became: \(row)\n") : ()
            //log ? print("Updating board...") : ()
            for indexAddition in startingIndex.stride(to: indexIterationLimit, by: iterationAmount) { // Similar to the other stride function previously mentioned, this line controls the direction in which the four rows of four numbers should be read
                //log ? print("baseIndex: \(baseIndex), indexAddition:\(indexAddition)") : ()
                if !isForControl {
                    switch direction {
                    case .Left:
                        board[baseIndex + indexAddition] = row[indexAddition]
                    case .Right:
                        board[baseIndex + (3 - indexAddition)] = row[indexAddition]
                    case .Up:
                        board[baseIndex + indexAddition] = row[indexAddition/4]
                    case .Down:
                        board[baseIndex + (12 - indexAddition)] = row[indexAddition/4]
                        
                    }
                    
                } else if isForControl {
                    switch direction {
                    case .Left:
                        controlBoard[baseIndex + indexAddition] = row[indexAddition]
                    case .Right:
                        controlBoard[baseIndex + (3 - indexAddition)] = row[indexAddition]
                    case .Up:
                        controlBoard[baseIndex + indexAddition] = row[indexAddition/4]
                    case .Down:
                        controlBoard[baseIndex + (12 - indexAddition)] = row[indexAddition/4]
                        
                    }
                }
                
            }
            
        }
        
    }
    
    
}















