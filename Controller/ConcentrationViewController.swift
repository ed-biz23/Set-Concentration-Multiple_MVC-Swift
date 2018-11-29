//
//  ViewController.swift
//  Concentration
//
//  Created by Edward Biswas on 8/27/18.
//  Copyright © 2018 Edward Biswas. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    
    // View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        startOver()
    }
    
    // lazy var intilialize when needed
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // Swift Dictionary
    private var emoji = [Card: String]()
    
    // Swift Array
    private var emojiChoices = [String]()
    
    // Swift Hash Table
    private var emojiThemeLibaries = [
        "Halloween": ["👻", "🎃", "😈", "☠️", "🧟‍♂️", "🍎", "🍬", "🍭", "🍫"],
        "Animal": ["🐶", "🐱", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁"],
        "Sport": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🏏", "🏓"],
        "Flag": ["🇧🇩", "🇺🇸", "🇨🇦", "🇲🇽", "🇦🇺", "🇧🇷", "🇭🇷", "🇨🇺", "🇬🇾"],
        "Horoscope": ["♈️", "♉️", "♊️", "♋️", "♌️", "♍️", "♎️", "♏️", "♐️"],
        "Food": ["🌭", "🍔", "🍟", "🍕", "🥪", "🥙", "🌮", "🍣", "🍜"]
    ]
    
    private var cardThemeColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    
    @IBOutlet weak var emojiThemeLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipsLabel()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var startOverButton: UIButton!
    
    private(set) var flipCount = 0 {
        didSet {
            updateFlipsLabel()
            
            //            flipCountLabel.text = "Flips: \(flipCount)" //Property observer
        }
    }
    
    private func updateFlipsLabel() {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0
        ]
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)",
            attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    private(set) var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)" //Property observer
        }
    }
    
    // Start New Game When Start Over Pressed
    @IBAction func startOverAction(_ sender: UIButton) {
        startOver()
    }
    
    // Execute this function when card is pressed
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            if game.isAllMatched() {
                let alert = UIAlertController(title: "Game Over",
                                              message: "Final Stats \nFlip Count: \(flipCount)  Final Score: \(score)",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Start New Game",
                                              style: .default,
                                              handler: {(alert: UIAlertAction!) in self.startOver()}))
                self.present(alert, animated: true)
            }
        } else {
            print("Chosen card was not in the collection")
        }
    }
    
    // Pick random emoji theme
    private func randomTheme() {
        let theme = Array(emojiThemeLibaries.keys)[emojiThemeLibaries.keys.count.arc4random]
        emojiChoices = emojiThemeLibaries[theme]!
        
        switch theme {
        case "Animal":
            cardThemeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        case "Sport":
            cardThemeColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        case "Flag":
            cardThemeColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        case "Horoscope":
            cardThemeColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case "Food":
            cardThemeColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        default:
            cardThemeColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            flipCountLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            scoreLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            emojiThemeLabel.text = theme
            emojiThemeLabel.textColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            self.view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
    // This function assign emoji to the card
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex,
                                                       offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }
    
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.cornerRadius = 10
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : cardThemeColor
                button.isEnabled = card.isMatched ? false : true
            }
        }
        score = game.score
        flipCount = game.flipCount
    }
    
    // Reset
    private func startOver() {
        flipCount = 0
        score = 0
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        randomTheme()
        startOverButton.setTitleColor(cardThemeColor, for: UIControlState.normal)
        updateViewFromModel()
    }
    
    
}

extension Int {
    var arc4random: Int {
        if (self > 0){
            return Int(arc4random_uniform(UInt32(self)))
        } else if (self < 0) {
            return Int(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}

