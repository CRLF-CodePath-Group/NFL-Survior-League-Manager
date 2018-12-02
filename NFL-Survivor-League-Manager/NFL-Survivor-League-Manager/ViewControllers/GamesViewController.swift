//
//  GamesViewController.swift
//  NFL-Survivor-League-Manager
//
//  Created by macstudent on 11/29/18.
//  Copyright © 2018 Jacob Frick. All rights reserved.
//

import UIKit

class GamesViewController: UIViewController, UICollectionViewDataSource, GameCellDelegate {
    var schedule : Schedule!
    var buttonState = [Bool]()
    var cell_num = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var awayTeamLogoImageView: UIImageView!
    @IBOutlet weak var homeTeamLogoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*   // Do any additional setup after loading the view, typically from a nib.
         let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
         layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
         layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
         layout.minimumInteritemSpacing = 0
         layout.minimumLineSpacing = 0
         collectionView!.collectionViewLayout = layout*/
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let screenSize = UIScreen.main.bounds
        
        layout.itemSize = CGSize(width:screenSize.width/2 , height:89)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.layer.borderColor = UIColor.white.cgColor
        collectionView.layer.borderWidth = 2
        collectionView!.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        for _ in 0...31 {
            self.buttonState.append(false)
        }
        NFLAPIManager.grabFullNFLSeason { (schedule, error) in
            if let schedule = schedule {
                self.schedule = schedule
                self.collectionView.reloadData()
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if schedule != nil {
            return schedule.games[10].count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath) as! GameCell
        //let game = games[indexPath.item]
        cell.delegate = self
        cell.awayTeamLabel.text = schedule.games[10][indexPath.item].awayTeam.rawValue
        cell.homeTeamLabel.text = schedule.games[10][indexPath.item].homeTeam.rawValue
        let awayImage = UIImage(imageLiteralResourceName: "\(schedule.games[10][indexPath.row].awayTeam.rawValue)")
        let homeImage = UIImage(imageLiteralResourceName: "\(schedule.games[10][indexPath.row].homeTeam.rawValue)")
        cell.cellNumber = indexPath.row
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.awayTeamLogoImageView.image = awayImage
        cell.homeTeamLogoImageView.image = homeImage
        let odd = (cell.cellNumber! * 2) + 1
        let even = (cell.cellNumber! * 2)
        if even % 2 == 0 && self.buttonState[even] == true {
            cell.awayTeamRadioButton.setImage(#imageLiteral(resourceName: "Radio Button Fill.png"), for: .normal)
        } else {
            cell.awayTeamRadioButton.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
        }
        if odd % 2 == 1 && self.buttonState[odd] == true {
            cell.homeTeamRadioButon.setImage(#imageLiteral(resourceName: "Radio Button Fill.png"), for: .normal)
        } else {
            cell.homeTeamRadioButon.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
        }
        return cell
    }
    
    func updateRadios(_ num: Int, _ isHomeTeam: Bool) {
        for i in 0...self.buttonState.count-1 {
            if i != num  && self.buttonState[i] == true {
                self.buttonState[i] = false
                var cellIdNum = Int()
                var isHomeTeam = Bool()
                if i % 2 == 0 {
                    cellIdNum = i/2
                    isHomeTeam = false
                } else {
                    cellIdNum = (i-1)/2
                    isHomeTeam = true
                }
                for cell in collectionView.visibleCells as! [GameCell] {
                    if cell.cellNumber! == cellIdNum{
                        if isHomeTeam {
                            cell.homeTeamRadioButon.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
                        }else {
                            cell.awayTeamRadioButton.setImage(#imageLiteral(resourceName: "Radio Button.png"), for: .normal)
                        }
                    }
                }
            }
        }
        self.buttonState[num] = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}