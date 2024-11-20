//
//  Game.swift
//  SDE200GroupProject
//
//  Created by student on 11/20/24.
//

import Foundation

struct Game: Codable {
    var winner: String
    var blackjack: Bool
    var playerScore: Int
    var dealerScore: Int
    
    static let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = docDir.appendingPathComponent("games").appendingPathExtension("plist")
    
    static func saveGameData(game: Game) {
        var games = loadGameData()
        // if there was no game data already found
        if games[0].winner == "Empty" {
            games[0] = game
        } else {
            games.append(game)
        }
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedGames = try? propertyListEncoder.encode(games)
        
        try? encodedGames?.write(to: Game.archiveURL, options: .noFileProtection)
    }
    
    static func loadGameData() -> [Game] {
        let propertyListDecoder = PropertyListDecoder()
        if let fromFile = try? Data(contentsOf: Game.archiveURL),
           let decodedGames = try? propertyListDecoder.decode([Game].self, from: fromFile){
            return decodedGames
        } else {
            return [Game(winner: "Empty", blackjack: false, playerScore: 0, dealerScore: 0)]
        }
    }
}
