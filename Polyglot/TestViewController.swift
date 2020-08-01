//
//  TestViewController.swift
//  Polyglot
//
//  Created by Eros Campos on 8/1/20.
//  Copyright © 2020 Eros Campos. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    var words: [String]!
    //We’ll use questionCounter to track which question is currently being asked. We’ll shuffle the array once when the view loads, then load whichever item is pointed to by questionCounter.
    var questionCounter = 0
    //The showingQuestion property will be either true or false, depending on whether we’re currently showing the question (true) or the answer (false).
    var showingQuestion = true
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var prompt: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        //The view was just shown - start asking the question
        askQuestion()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextTapped))
        
            //Shuffle the words
            words.shuffle()
            title = "Test"
        
        //Hide the initial stackview
        stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        stackView.alpha = 0
    }
    
    @objc func nextTapped() {
        //Move between showing questions and answers
        showingQuestion = !showingQuestion
        
        if showingQuestion {
            //We should be showing the question - reset!
            prepareForNextQuestion()
        } else {
            //We should be showing the answer - show it now, and set the color to green
            prompt.text = words[questionCounter].components(separatedBy: "::")[0]
            
            prompt.textColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        }
    }
    
    func askQuestion() {
        //Move the question counter one place
        questionCounter += 1
        if questionCounter == words.count {
            //Go back to 0 since we reached the end of the array
            questionCounter = 0
        }
        
        //Pull out the French word at the current question position
        prompt.text = words[questionCounter].components(separatedBy: "::")[1]
        
        //Give a custom animation
        let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5, animations: {
            self.stackView.alpha = 1
            self.stackView.transform = CGAffineTransform.identity
        })
        
        animation.startAnimation()
    }
    
    func prepareForNextQuestion() {
        //Scale the stackview to 80% and then dissapear it
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [unowned self] in
            self.stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.stackView.alpha = 0
        })
        
        //Do this after the animation ends
        animation.addCompletion({ [unowned self] position in
            //Reset the prompt back to black
            self.prompt.textColor = UIColor.black
            
            //Proceed with the next question
            self.askQuestion()
        })
        
        animation.startAnimation()
    }
}
