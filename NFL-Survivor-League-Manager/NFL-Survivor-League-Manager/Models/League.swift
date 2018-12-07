//
//  League.swift
//  NFL-Survivor-League-Manager
//
//  Created by Jacob Frick on 11/28/18.
//  Copyright © 2018 Jacob Frick. All rights reserved.
//

import Foundation
import Parse
class League : PFObject, PFSubclassing{

    
    @NSManaged var owner : String
    @NSManaged var leagueName : String
    @NSManaged var currentWeek : Int
    @NSManaged var aliveMembers : [String]
    @NSManaged var deadMembers : [String]
    @NSManaged var hasStarted : Bool
    @NSManaged var picks : [String : [String]]
    
    override init() {
        super.init()
    }
    init(_ leagueName: String, _ ownerName: String) {
        super.init()
        self.owner = ownerName
        self.leagueName = leagueName
        self.currentWeek = 1
        self.aliveMembers = [String]()
        self.deadMembers = [String]()
        self.picks = [String : [String]]()
        self.hasStarted = false
    }
    
    func addAliveMember(_ memmberId: String) {
        var doesContain = false
        for s in self.aliveMembers {
            if s == memmberId {
                doesContain = true
                break
            }
        }
        if !doesContain {
            self.aliveMembers.append(memmberId)
            self.picks[memmberId] = [String]()
        }
        self.saveInBackground()
    }
    func didUserPick(_ team: Team) -> Bool{
        let picks = self.picks[(PFUser.current()?.objectId)!]

        for pick in picks! {
            if pick == team.rawValue {
                return true
            }
        }
        return false
    }
    func addUserPick(_ team: Team/*, _ id: String*/)
    {
        let user = PFUser.current()?.objectId
        var picks = self.picks[user!]
        for pick in picks!
        {
            if pick == team.rawValue
            {
                picks?.append(team.rawValue)
            }
        }
        
    }
    static func parseClassName() -> String {
        return "League"
    }

}

