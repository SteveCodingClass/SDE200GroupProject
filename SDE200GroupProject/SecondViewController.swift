//
//  SecondViewController.swift
//  SDE200GroupProject
//
//  Created by student on 10/24/24.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var playerCardsStackView: UIStackView!
    
    @IBOutlet weak var dealerCardsStackView: UIStackView!
    
    @IBOutlet weak var playerScoreLabel: UILabel!
    
    @IBOutlet weak var dealerScoreLabel: UILabel!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var intro = "Welcome to Blackjack "
    var nameLabelText = ""
    
    var deckOfCards: [String] = []
    var valueArray: [Int] = []
    var playerScore: Int = 0
    var dealerScore: Int = 0
    var turnCount: Int = 0
    
    var currentPlayerCards: [(String, Int)] = []
    var playerArray: [String: [(String,Int)]] = [:]
    var dealerArray: [String: [(String,Int)]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = intro + nameLabelText
        let viewController = ViewController()
        let deck = viewController.createDeck()
        deckOfCards = deck.0
        valueArray = deck.1
    }
    
    @IBAction func dealButtonTapped(_ sender: UIButton) {
        
        let card = pickRandomCard()
        addCardToStackView(card: card, stackView: playerCardsStackView)
        playerScore += card.1
        
        currentPlayerCards.append(card)
        playerScoreLabel.text = "Player One: \(playerScore)"
        }
        
        @IBAction func holdButtonTapped(_ sender: UIButton) {
            turnCount += 1
            playerArray["play\(turnCount)"] = currentPlayerCards
            
            dealerScore = 0
            dealerCardsStackView.arrangedSubviews.forEach { $0.removeFromSuperview()}
            dealDealerCards()
        }
        
        func pickRandomCard() -> (String, Int) {
            let randomIndex = Int(arc4random_uniform(UInt32(deckOfCards.count)))
            let randomCard = deckOfCards[randomIndex]
            let cardValue = valueArray[randomIndex]
            
            return (randomCard, cardValue)
        }
        
        func addCardToStackView(card: (String, Int), stackView: UIStackView) {
            let cardImageView = UIImageView()
            cardImageView.image = UIImage(named: card.0)
            cardImageView.contentMode = .scaleAspectFit
            cardImageView.translatesAutoresizingMaskIntoConstraints = false
            cardImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            cardImageView.widthAnchor.constraint(equalToConstant: 67).isActive = true
            stackView.addArrangedSubview(cardImageView)
        }
        
        func dealDealerCards() {
            var currentDealerCards: [(String, Int)] = []
            
            DispatchQueue.global().async {
                while self.dealerScore < 21 {
                    let card = self.pickRandomCard()
                    DispatchQueue.main.sync {
                        self.addCardToStackView(card: card, stackView: self.dealerCardsStackView)
                        self.dealerScore += card.1
                        currentDealerCards.append(card)
                        self.dealerScoreLabel.text = "Dealer Score: \(self.dealerScore)"
                    }
                    sleep(2)
                    if self.dealerScore >= 21{
                        self.dealerArray["play\(self.turnCount)"] = currentDealerCards
                        self.determinWinner()
                        return
                    } else if self.dealerScore > 21 {
                        self.dealerArray["play\(self.turnCount)"] = currentDealerCards
                        self.determinWinner()
                        return
                    }
                }
                DispatchQueue.main.async {
                    self.dealerArray["play\(self.turnCount)"] = currentDealerCards
                    self.determinWinner()
                }
            }
        }
    
    func determinWinner() {
        guard let playerScore = playerScoreLabel.text, let dealerScore = dealerScoreLabel.text else{
            resultLabel.text = "error calculating scores"
            return
        }
        let playerDifference = abs(21 - self.playerScore)
        let dealerDifference = abs(21 - self.dealerScore)
        let playerFinal = self.playerScore
        let dealerFinal = self.dealerScore
        
        if playerDifference < dealerDifference {
            resultLabel.text = "Player WINS !"
        } else if dealerDifference <= playerDifference {
            resultLabel.text = "Dealer WINS !"
        } else {
            resultLabel.text = "It's a tie match!"
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

} // End of main class
