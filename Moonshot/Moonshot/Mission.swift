//
//  Mission.swift
//  Moonshot
//
//  Created by 陶涛 on 2021/8/19.
//

import Foundation


struct Mission: Codable, Identifiable {
    
    struct CrewRole: Codable {
        let name: String
        let role: String
    }
    
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        guard let launchDate = launchDate else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: launchDate)
    }
    
    static func loadData() -> [Mission] {
        let missions: [Mission] = Bundle.main.decode("missions.json")
        return missions
    }

}
