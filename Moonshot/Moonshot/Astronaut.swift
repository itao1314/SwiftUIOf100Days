//
//   Astronaut.swift
//  Moonshot
//
//  Created by 陶涛 on 2021/8/19.
//

import Foundation

struct  Astronaut: Codable, Identifiable {
    var id: String
    var name: String
    var description: String
    
    static func loadData() -> [Astronaut] {
        let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
        return astronauts
    }
    
}
