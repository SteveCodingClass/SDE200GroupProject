//
//  ViewController.swift
//  SDE200GroupProject
//
//  Created by student on 10/24/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nameText: UITextField!
    
    @IBOutlet weak var coollabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Create the card deck
        let (deckOfCards, valuesArray) = createDeck()
        // Create the random card
        let (randomCard, cardValue) = pickRandomCard(deckOfCards: deckOfCards, valueArray: valuesArray)
        // using function displayCard place the card in full screen
        displayCardOnMainScreen(card: randomCard)
        
    } // End of View Controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
       let secondVC = segue.destination as? SecondViewController
        secondVC?.nameLabelText = nameText.text!
        //segue.destination.navigationItem.title = nameText.text
    }
    
    @IBAction func unwindToFirst(unwindSegue: UIStoryboard){
        
    }
    
    func createDeck()-> ([String], [Int]){
            // each suit of a card
            let suits = ["hearts", "spades", "clubs", "diamonds"]
            // each value name of the card
            let ranks = ["ace", "2", "3", "4", "5", "6", "7", "8", "9", "10", "jack", "queen", "king"]
            // Values of each card
            let values = [1,2,3,4,5,6,7,8,9,10,10,10,10]
            // new variable for array of cards created with loop
            var deckOfCards = [String]()
            var valuesArray = [Int]()
            
            // Loop to create the deck with concatenation of string names to match values of assets
            for suit in suits{
                for (index, rank) in ranks.enumerated(){
                    deckOfCards.append("\(rank)_of_\(suit)")
                    if rank == "ace"{
                        valuesArray.append(1) // Create additional logic to change this value as needed.
                    } else {
                        valuesArray.append(values[index])
                    }
                }
            }
            return (deckOfCards, valuesArray)
        } // End of createDeck function
    
    func pickRandomCard(deckOfCards: [String], valueArray: [Int]) -> (String, Int){
        let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
        let randomCard = deckOfCards[randomIndex]
        let cardValue = valueArray[randomIndex]
        
        return (randomCard, cardValue)
    } // End of pickRandomCard function
    
    func displayCardOnMainScreen(card: String){
        // To display the card value add into function after card: String, value: Int
        // Also , uncomment out cardLabel.text and add value into function call in main 
        // Display the card label
        let cardLabel = UILabel()
        //cardLabel.text = "\(card) , Value: \(value)"
        cardLabel.textAlignment = .center
        cardLabel.frame = self.view.bounds
        // Display the card image
        let cardImageView = UIImageView()
        cardImageView.image = UIImage(named: card)
        cardImageView.contentMode = .scaleAspectFit
        cardImageView.frame = self.view.bounds
        
        // Frame for image
        let imageHeight: CGFloat = self.view.bounds.height * 0.8
        cardImageView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: imageHeight)
        
        // Frame for label
        cardLabel.frame = CGRect(x: 0, y: imageHeight, width: self.view.bounds.width, height: self.view.bounds.height -  imageHeight)
        
        self.view.addSubview(cardImageView)
        //self.view.addSubview(cardLabel)
    }
    
} // End of main class

