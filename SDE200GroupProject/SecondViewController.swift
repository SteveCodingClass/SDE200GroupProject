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
    
    // Deal the player a card on tap
    @IBAction func hitButtonTapped(_ sender: UIButton) {
        let card = pickRandomCard()
        addCardToStackView(card: card, stackView: playerCardsStackView)
        playerScore += card.1
        
        currentPlayerCards.append(card)
        playerScoreLabel.text = "Player One: \(playerScore)"
        }
        
    // Begin dealing dealer's cards
    @IBAction func standButtonTapped(_ sender: UIButton) {
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
    
    func resetBoard() {
        DispatchQueue.main.async {
            for i in self.playerCardsStackView.arrangedSubviews {
                i.removeFromSuperview()
            }
            for i in self.dealerCardsStackView.arrangedSubviews {
                i.removeFromSuperview()
            }
            self.playerScore = 0; self.playerScoreLabel.text = "Player Score: "
            self.dealerScore = 0; self.dealerScoreLabel.text = "Dealer Score: "
            self.resultLabel.isHidden = true
        }
    }
    
    func dealDealerCards() {
        var currentDealerCards: [(String, Int)] = []
        let queue = DispatchQueue(label: "update")
        
        queue.async {
            while self.dealerScore < 17 {
                let card = self.pickRandomCard()
                DispatchQueue.main.async {
                    self.addCardToStackView(card: card, stackView: self.dealerCardsStackView)
                    self.dealerScore += card.1
                    currentDealerCards.append(card)
                    self.dealerScoreLabel.text = "Dealer Score: \(self.dealerScore)"
                }
                usleep(500000) // 500 milliseconds
                if self.dealerScore >= 21{
                    self.dealerArray["play\(self.turnCount)"] = currentDealerCards
                    self.determineWinner()
                    return
                } else if self.dealerScore > 21 {
                    self.dealerArray["play\(self.turnCount)"] = currentDealerCards
                    self.determineWinner()
                    return
                }
            }
            
            self.dealerArray["play\(self.turnCount)"] = currentDealerCards
            self.determineWinner()
        }
    }
    
    
    func determineWinner() {
        let result: String
        var blackjack: Bool = false
        if self.playerScore <= 21 && (self.playerScore > self.dealerScore || self.dealerScore > 21) {
            if self.playerScore == 21 {blackjack = true}
            result = "Player WINS !"
        } else if (self.playerScore > 21 || self.dealerScore > self.playerScore) && self.dealerScore <= 21 {
            if self.dealerScore == 21 {blackjack = true}
            result = "Dealer WINS !"
        } else {
            result = "PUSH !"
        }
        Game.saveGameData(game: Game(winner: result, blackjack: blackjack, playerScore: self.playerScore, dealerScore: self.dealerScore))
        DispatchQueue.main.async {
            self.resultLabel.text = result
            self.resultLabel.isHidden = false
        }
        sleep(2)
        self.resetBoard()
        
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
