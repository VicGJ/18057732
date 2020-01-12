//
//  ViewController.swift
//  final
//
//  Created by vg19aaf on 16/12/2019.
//  Copyright © 2019 vg19aaf. All rights reserved.
//


import UIKit
import AVFoundation

protocol subViewDelegate {
    func changeSomething()
    func updateAngle(x: CGFloat, y: CGFloat)
}

class ViewController: UIViewController, subViewDelegate
{
    //Dynamics and collision
    var dynamicAnimator: UIDynamicAnimator!
    var dynamicItemBehavior: UIDynamicItemBehavior!
    var birdsCollisionBehavior: UICollisionBehavior!
    var ballsCollisionBehavior: UICollisionBehavior!
    
    //Sounds
    var ballMusic: AVAudioPlayer?
    var backgroundMusic: AVAudioPlayer?
    var hitMusic: AVAudioPlayer?
    var winMusic: AVAudioPlayer?
    
    //Variables
    var score = 0
    var x:CGFloat?
    var y: CGFloat?
    var angleX: CGFloat?
    var angleY: CGFloat?
    var gameFinish = false
    let W = UIScreen.main.bounds.size.width
    let H = UIScreen.main.bounds.size.height
    let up = CGPoint(x: UIScreen.main.bounds.size.height*2, y: 0)
    let left = CGPoint(x: 0, y: 350)
    let down = CGPoint(x: UIScreen.main.bounds.size.height*2, y: 470)
    let start = CGPoint(x: 0, y: 0)
    var seconds = 17
    var timer = Timer()
    //total score after the 3 levels
    var result = 0
    //space for birds
    var space = true
    var spaces: [Bool] = [false, false, false, false, false, false]
    var lvl = 0
    //boolean for night mode
    var night = false
    //Labels and images
    @IBOutlet weak var aimNight: DraggedImageNight!
    @IBOutlet weak var nextLevelButton: UIButton!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var finalScore: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var aim: DraggedImageView!
    
    @IBOutlet weak var resultScore: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var nightButton: UIButton!
    @IBOutlet weak var square1: UIImageView!
    @IBOutlet weak var square2N: UIImageView!
    @IBOutlet weak var square2: UIImageView!
    @IBOutlet weak var square1N: UIImageView!
    
    //array of birds and balls
    var birds: [UIImageView] = []
    var balls: [UIImageView] = []
    
    func changeSomething() {
        //Create a new UIImageViewfrom scratch
        let ballView = UIImageView(image: nil)
        //Assign animage to the image view
        ballView.image = UIImage(named: "ball.png")
        //Assign the size and position of the image view
        if(!night){
        ballView.frame = CGRect(x:self.aim.currentLocation!.x, y: self.aim.currentLocation!.y, width: 60, height: 60)
        }
        else{
            ballView.frame = CGRect(x:self.aimNight.currentLocation!.x, y: self.aimNight.currentLocation!.y, width: 60, height: 60)
        }
        //Add the image view to the main view
        self.view.addSubview(ballView)
        
        
        let path = Bundle.main.path(forResource: "shot", ofType:"mp3")!
        let url = URL(fileURLWithPath: path)
        
        do {
            ballMusic = try AVAudioPlayer(contentsOf: url)
            ballMusic?.play()
        } catch {
            // couldn't load file
        }
        
        balls.append(ballView)
        
        dynamicItemBehavior.addItem(ballView)
        dynamicItemBehavior.addLinearVelocity(CGPoint(x: angleX!, y: angleY!), for: ballView)
        dynamicAnimator.addBehavior(dynamicItemBehavior)
        
        for ball1 in balls{
            for ball2 in balls{
                ballsCollisionBehavior = UICollisionBehavior(items: [ball1, ball2])
                dynamicAnimator.addBehavior(ballsCollisionBehavior)
                }
        }
        
            
        //up
        ballsCollisionBehavior.addBoundary(withIdentifier: "up" as NSCopying, from: start, to: up)
        
        //left
        ballsCollisionBehavior.addBoundary(withIdentifier: "left" as NSCopying, from: start, to: left)
        
        //down
        ballsCollisionBehavior.addBoundary(withIdentifier: "down" as NSCopying, from: left, to: down)
        
        if(self.lvl == 1)
        {
        ballsCollisionBehavior.addBoundary(withIdentifier: "barrier" as NSCopying, for: UIBezierPath(rect: square1.frame))
        }
        else if(self.lvl == 2)
        {
            ballsCollisionBehavior.addBoundary(withIdentifier: "barrier2" as NSCopying, for: UIBezierPath(rect: square2.frame))
        }
        dynamicAnimator.addBehavior(ballsCollisionBehavior)
    }
    
    func updateAngle(x:CGFloat,y:CGFloat){
        angleX = x
        angleY = y
    }
    
    
    func createBird(){
        let birdView = UIImageView(image: nil)
        var birdsArray: [String]!
        
        birdsArray=["bird1.png",
                    "bird2.png",
                    "bird3.png",
                    "bird4.png",
                    "bird5.png",
                    "bird6.png",
                    "bird7.png",
                    "bird8.jpg",
                    "bird9.png",
                    "bird10.png",
                    "bird11.png",
                    "bird12.png",
                    "bird13.png"]
        
        let randomBird = birdsArray.randomElement()
        
        let random = Int.random(in: 0 ... 5)
        
        if(self.spaces[random] == false)
        {
            self.spaces[random] = true
            
            birdView.frame = CGRect(x: Int(UIScreen.main.bounds.size.height*2), y: 70*random, width: 70, height: 70)
            birdView.image = UIImage(named: randomBird!)
            self.view.addSubview(birdView)
            birds.append(birdView)
            birdsCollisionBehavior.translatesReferenceBoundsIntoBoundary = true
            dynamicAnimator.addBehavior(birdsCollisionBehavior)
            
            dynamicItemBehavior.addItem(birdView)
            dynamicAnimator.addBehavior(dynamicItemBehavior)
        }
    }
    
    //Creates random birds throughout the view
    func createBirds(){
        let appear = Double.random(in: 1 ... 3)
        let timer = DispatchTime.now() + Double(appear)
        DispatchQueue.main.asyncAfter(deadline: timer){
            if (!self.gameFinish){
                self.createBird()
                self.createBirds()
            }
        }
    }
    
    //night mode
    @IBAction func nightMode(_ sender: Any) {
        if(!self.gameFinish){
            if(!self.night){
                self.aimNight.isHidden = false
                self.aim.isHidden = true
                self.night = true
                if(self.lvl == 1)
                {
                    self.square1.isHidden = true
                    self.square1N.isHidden = false
                    self.view.bringSubviewToFront(self.square1)
                }
                else if(self.lvl == 2){
                    self.square2.isHidden = true
                    self.square2N.isHidden = false
                    self.view.bringSubviewToFront(self.square2)
                }
                self.view.backgroundColor = UIColor.black
            }
            else
            {
                self.aim.isHidden = false
                self.aimNight.isHidden = true
                self.night = false
                if(self.lvl == 1)
                {
                    self.square1.isHidden = false
                    self.square1N.isHidden = true
                    self.view.bringSubviewToFront(self.square1N)
                }
                else if(self.lvl == 2){
                    self.square2.isHidden = false
                    self.square2N.isHidden = true
                    self.view.bringSubviewToFront(self.square2N)
                }
                self.view.backgroundColor = UIColor.white
            }
        }
    }
    
    //next level button
    @IBAction func nextButton(_ sender: UIButton) {
        self.lvl += 1
        self.gameFinish = false
        seconds = 17
        if(!self.night)
        {
            self.aim.isHidden = false
        }
        else{
            self.aimNight.isHidden = false
        }
        self.nextLevelButton.isHidden = true
        if(self.lvl == 1)
        {
            level1()
        }
        else if(self.lvl == 2)
        {
            level2()
        }
    }
    
    //display level 1
    func level1(){
        deleteBalls()
        self.score = 0
        updateLabel()
        self.seconds = 17
        updateTimer()
        self.gameFinish = false
        
        self.aim.isHidden = false
        self.timeLabel.isHidden = false
        self.scoreLabel.isHidden = false
        if(!self.night){
            self.square1.isHidden = false
            self.square2.isHidden = true
            self.view.bringSubviewToFront(self.square1)
        }
        else{
             self.square1N.isHidden = false
             self.square2N.isHidden = true
            self.view.bringSubviewToFront(self.square1N)
        }
        
        play()
    }
    
    //display level 2
    func level2(){
        deleteBalls()
        self.score = 0
        updateLabel()
        self.seconds = 17
        updateTimer()
        self.gameFinish = false
        self.aim.isHidden = false
        self.timeLabel.isHidden = false
        self.scoreLabel.isHidden = false
        if(!self.night){
            self.square2.isHidden = false
            self.square1.isHidden = true
            self.view.bringSubviewToFront(self.square2)
        }
        else{
             self.square2N.isHidden = false
             self.square1N.isHidden = true
            self.view.bringSubviewToFront(self.square2N)
        }
        play()
    }
    
    //Updates the score label each time an event happens
    func updateLabel(){
        scoreLabel.text = "Score: " + String(self.score)
    }
    
    //Updates the final result of the game
    func updateResult(){
        self.result += self.score
        self.resultScore.text = String(result)
    }
    
    @objc func updateTimer(){
        seconds -= 1
        self.timeLabel.text = "Time: " + String(self.seconds)
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    //delete all birds in screen
    func deleteBirds(){
            var i = 0
            while (i < birds.count){
                birds[i].frame = .zero
                birds[i].removeFromSuperview()
                i += 1
            }
        var j = 0
        while (j < self.spaces.count)
        {
            self.spaces[j] = false
            j += 1
        }
        birds.removeAll()
    }
    
    //delete all balls in screen
    func deleteBalls(){
            var i = 0
            while (i < balls.count){
                balls[i].frame = .zero
                balls[i].removeFromSuperview()
                i += 1
        }
        balls.removeAll()
    }
    
    //main function
    func play(){
        runTimer()
        
        self.replayButton.isHidden = true
        self.finalScore.isHidden = true
        
        if(lvl == 2)
        {
            let when = DispatchTime.now() + 17
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.displayWin()
            }
        }
        else
        {
            let when = DispatchTime.now() + 17
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.displayGameOver()
            }
        }
        
            aim.myDelegate = self
            aimNight.myDelegate = self
            dynamicAnimator = UIDynamicAnimator(referenceView: self.view)
            dynamicItemBehavior = UIDynamicItemBehavior(items: [])
        
            let path = Bundle.main.path(forResource: "bg.mp3", ofType:nil)!
            let url = URL(fileURLWithPath: path)
            do {
                backgroundMusic = try AVAudioPlayer(contentsOf: url)
                backgroundMusic?.numberOfLoops = -1
                backgroundMusic?.play()
            } catch {
                // couldn't load file
            }
        
            createBirds()
            birdsCollisionBehavior = UICollisionBehavior(items: [])
            birdsCollisionBehavior.translatesReferenceBoundsIntoBoundary = true
            dynamicAnimator.addBehavior(birdsCollisionBehavior)
                   
            birdsCollisionBehavior.action = {
                var i = 0
                var j = 0
                while (i < self.birds.count){
                    while(j < self.balls.count){
                        if (self.birds[i].frame.intersects(self.balls[j].frame)){
                            let path = Bundle.main.path(forResource: "hit.mp3", ofType:nil)!
                            let url = URL(fileURLWithPath: path)
                            do {
                                self.hitMusic = try AVAudioPlayer(contentsOf: url)
                                self.hitMusic?.play()
                            } catch {
                                    // couldn't load file
                            }
                            let pos = Int((self.birds[i].frame.origin.y))/70
                            self.spaces[pos] = false
                            self.birdsCollisionBehavior.removeItem(self.birds[i])
                            self.birds[i].frame = .zero
                            self.birds[i].removeFromSuperview()
                            self.birds.remove(at: i)
                            
                            self.ballsCollisionBehavior.removeItem(self.balls[j])
                            self.balls[j].frame = .zero
                            self.balls[j].removeFromSuperview()
                            self.balls.remove(at: j)
                                
                            self.score += 10
                            self.updateLabel()
                            self.updateResult()
                        }
                        j += 1
                    }
                    j = 0
                    i += 1
                }
            }
            
            
       scoreLabel.text = "Score: " + String(self.score)
    }
    
    //replay button
    @IBAction func replayButton(_ sender: UIButton) {
        //Restart all the components
        score = 0
        seconds = 17
        self.deleteBalls()
        self.deleteBirds()
        if(!self.night)
        {
            self.aim.isHidden = false
        }
        else{
            self.aimNight.isHidden = false
        }
        gameFinish = false
        self.endLabel.isHidden = true
        self.timeLabel.isHidden = false
        self.scoreLabel.isHidden = false
        self.resultScore.isHidden = true
        self.nextLevelButton.isHidden = true
        play()
    }
    
    //aux function to display win
    func hideEverything(){
        self.deleteBirds()
        self.deleteBalls()
        
        self.finalScore.isHidden = true
        self.gameFinish = true
        self.scoreLabel.isHidden = true
        self.aim.isHidden = true
        self.aimNight.isHidden = true
        self.replayButton.isHidden = false
        self.timeLabel.isHidden = true
        self.nextLevelButton.isHidden = true
        self.square1.isHidden = true
        self.square1N.isHidden = true
        self.square2.isHidden = true
        self.square2N.isHidden = true
        
        self.backgroundMusic?.stop()
        let path = Bundle.main.path(forResource: "win.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            winMusic = try AVAudioPlayer(contentsOf: url)
            winMusic?.play()
        } catch {
            // couldn't load file
        }
        
        self.endLabel.isHidden = false
        self.view.bringSubviewToFront(self.endLabel)
        self.resultScore.isHidden = false
        self.resultScore.text = "Final Score: " + String(self.result)
        self.view.bringSubviewToFront(self.resultScore)
        
        self.timer.invalidate()
    }
    
    //after the level 2
    func displayWin(){
        hideEverything()
        self.lvl = 0
        self.result = 0
        self.score = 0
    }
    
    //after each level except level 2
    func displayGameOver(){
        
        self.deleteBirds()
        self.deleteBalls()
        self.view.bringSubviewToFront(self.finalScore)
        self.finalScore.text = "Score: " + String(self.score)
        self.finalScore.isHidden = false
        self.gameFinish = true
        self.scoreLabel.isHidden = true
        self.aim.isHidden = true
        self.aimNight.isHidden = true
        self.replayButton.isHidden = false
        self.timeLabel.isHidden = true
        self.resultScore.isHidden = true
        self.timer.invalidate()
        self.endLabel.isHidden = true
        self.view.bringSubviewToFront(self.replayButton)
        self.square1.isHidden = true
        self.square1N.isHidden = true
        self.square2.isHidden = true
        self.square2N.isHidden = true
        if (self.lvl == 1){
            self.nextLevelButton.isHidden = false
            self.view.bringSubviewToFront(self.nextLevelButton)
        }
        else{
            self.nextLevelButton.isHidden = false
            self.view.bringSubviewToFront(self.nextLevelButton)
            
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        play()
    }

        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

}

