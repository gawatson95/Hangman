//
//  ViewController.swift
//  Hangman
//
//  Created by Grant Watson on 9/23/22.
//

import UIKit

class ViewController: UIViewController {
    
    var letterBank: UIView!
    var letterButtons = [UIButton]()
    var guessesLeftLabel: UILabel!
    var blanksView: UILabel!
    var gameOver: Bool = false
    var guesses = 7 {
        didSet {
            guessesLeftLabel.text = "Guesses left: \(guesses)"
        }
    }
    var word = "CHEESE"
    var wordLetters = [String]()
    var wordBlanks = [String]()
    
    let letters: [String] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L",
                             "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X",
                             "Y", "Z", " ", " ", " ", " ", " ", " "
                            ]

    override func viewDidLoad() {
        super.viewDidLoad()
        getRandomWord()
        configureGuessesLeftLabel()
        configureLetterBank()
        configureBlanks()
    }
    
    func configureBlanks() {
        blanksView = UILabel()
        let wordLength = word.count
        blanksView.translatesAutoresizingMaskIntoConstraints = false
        blanksView.font = UIFont.systemFont(ofSize: 30)
        blanksView.textAlignment = .center
        
        for _ in 0..<wordLength {
            wordBlanks.append("?")
        }
        
        for letter in word {
            wordLetters.append(String(letter).uppercased())
        }
        print(wordLetters)
        
        blanksView.text = wordBlanks.joined()
        
        view.addSubview(blanksView)
        
        NSLayoutConstraint.activate([
            blanksView.topAnchor.constraint(equalTo: letterBank.bottomAnchor, constant: 50),
            blanksView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            blanksView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            blanksView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func configureGuessesLeftLabel() {
        guessesLeftLabel = UILabel()
        guessesLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        guessesLeftLabel.font = UIFont.systemFont(ofSize: 30)
        guessesLeftLabel.text = "Guesses left: \(guesses)"
        guessesLeftLabel.textAlignment = .center
        view.addSubview(guessesLeftLabel)
        
        NSLayoutConstraint.activate([
            guessesLeftLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            guessesLeftLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            guessesLeftLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            guessesLeftLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func configureLetterBank() {
        letterBank = UIView()
        letterBank.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(letterBank)
        
        NSLayoutConstraint.activate([
            letterBank.topAnchor.constraint(equalTo: guessesLeftLabel.bottomAnchor, constant: 20),
            letterBank.heightAnchor.constraint(equalToConstant: 250),
            letterBank.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 45),
            letterBank.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -45)
        ])
        
        let width = 50
        let height = 50

        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 44)
                letterButton.setTitle("A", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButton.titleLabel?.textAlignment = .center
                
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                letterBank.addSubview(letterButton)
                letterButtons.append(letterButton)
            }
        }
        
        for i in 0..<letterButtons.count {
            letterButtons[i].setTitle(letters[i], for: .normal)
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let letterSelected = sender.titleLabel?.text else { return }
        
        if wordLetters.contains(letterSelected) {
            for (index, letter) in wordLetters.enumerated() {
                if letterSelected == letter {
                    wordBlanks[index] = letter
                    blanksView.text = wordBlanks.joined()
                }
            }
        } else {
            guesses -= 1
        }
        
        sender.isHidden = true
        
        if guesses == 0 {
            resetGame()
        }
        
        if wordLetters == wordBlanks {
            let ac = UIAlertController(title: "Good Job!", message: "You guessed the word \(word)!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Next word", style: .default))
            present(ac, animated: true)
            resetGame()
        }
    }
    
    func resetGame() {
        let ac = UIAlertController(title: "Game Over!", message: "You ran out of guesses! The word to guess was \(word)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "New Game", style: .default))
        present(ac, animated: true)
        
        guesses = 7
        getRandomWord()
        
        for letter in letterButtons {
            letter.isHidden = false
        }
        
        wordBlanks = []
        for _ in 0..<word.count {
            wordBlanks.append("?")
        }
        
        wordLetters.removeAll()
        for letter in word {
            wordLetters.append(String(letter))
        }

        blanksView.text = wordBlanks.joined()
    }
    
    func getRandomWord() {
        if let url = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let words = try? String(contentsOf: url) {
                let allWords = words.components(separatedBy: "\n")
                word = allWords.randomElement()!.uppercased()
                print(word)
            }
        }
        print("DONE")
    }
}

