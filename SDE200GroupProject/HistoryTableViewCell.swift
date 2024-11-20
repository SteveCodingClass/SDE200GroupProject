//
//  HistoryTableViewCell.swift
//  SDE200GroupProject
//
//  Created by student on 11/20/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var blackjackLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with game: Game) {
        winnerLabel.text = game.winner
        scoreLabel.text = String(game.playerScore)+" - "+String(game.dealerScore)
        blackjackLabel.isHidden = !game.blackjack
    }

}
