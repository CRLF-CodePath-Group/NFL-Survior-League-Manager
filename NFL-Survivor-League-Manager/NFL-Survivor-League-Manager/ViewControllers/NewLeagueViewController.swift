//
//  NewLeagueViewController.swift
//  NFL-Survivor-League-Manager
//
//  Created by Jacob Frick on 11/28/18.
//  Copyright © 2018 Jacob Frick. All rights reserved.
//

import UIKit
import Parse
class NewLeagueViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var newLeagueNameTextField: UITextField!
    
    @IBOutlet weak var userFoundLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userInviteTextField: UITextField!
    var toBeInvitedUsers = [String]()
    var foundUsers = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        userFoundLabel.text = ""
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapInvite(_ sender: Any) {
    
        if !(self.userInviteTextField.text?.isEmpty)! {
            if self.userInviteTextField.text != PFUser.current()?.username {
                ParseAPIManager.findUserByUsername(self.userInviteTextField.text!) { (user, success) in
                    if success! {
                        self.userFoundLabel.text = "User found"
                        print("was sucess")
                        var alreadyFound = false
                        for foundUser in self.foundUsers {
                            if user?.username == foundUser.username {
                                alreadyFound = true
                            }
                        }
                        if alreadyFound {
                            self.userFoundLabel.text = "User already found"
                        } else {
                            self.foundUsers.append(user!)
                            self.tableView.reloadData()
                            self.userFoundLabel.text = "User found"
                        }
                        self.userInviteTextField.text = ""
                    } else {
                        self.userFoundLabel.text = "User not found"
                    }
                }
            } else {
                self.userFoundLabel.text = "Trying to find yourself?"
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    @IBAction func didTapCancel(_ sender: Any) {
        performSegue(withIdentifier: "toSurvivorHub", sender: nil)
    }
    
    @IBAction func didTapCreate(_ sender: Any) {
        
        if !((self.newLeagueNameTextField.text?.isEmpty)!) {
            ParseAPIManager.createNewLeague((PFUser.current()?.username)!, self.newLeagueNameTextField.text!) { (league, error) in
                if let league = league {
                    if(self.foundUsers.count > 0) {
                        ParseAPIManager.sendUsersInvites(self.foundUsers, league)
                    }
                    let user = PFUser.current() as! User
                    user.addLeague(league.objectId!)
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
                
            }
            
    
        }
        performSegue(withIdentifier: "toSurvivorHub", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.foundUsers.count == 0 {
            return 1
        } else {
            return self.foundUsers.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newUserInviteCell", for: indexPath) as! NewUserInviteCell
        if self.foundUsers.count == 0 {
            cell.usernameInviteLabel.text = "No users added :("
        } else {
            cell.usernameInviteLabel.text = self.foundUsers[indexPath.row].username
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurvivorHub" {
            usleep(400000)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableViews"), object: nil)
        }
    }
}
