//
//  RegisterHistoryVM.swift
//  NuGuNa
//
//  Created by 시모니 on 2/6/24.
//

import Foundation

class RegisterHistoryVM {
    
    struct PetitionResponse: Codable {
        let results: [Petition]
    }

    struct Petition: Codable {
        let raffleCheck: Bool
        let billName: String
        let debateCodeO: String
        let debateCodeX: String
        let position: Int

        enum CodingKeys: String, CodingKey {
            case raffleCheck = "raffle_check"
            case billName = "bill_name"
            case debateCodeO = "debate_code_O"
            case debateCodeX = "debate_code_X"
            case position = "position"
        }
    }
    
    var petitions: [Petition] = []

    
    let getListURL = "http://3.34.164.96:8000/debates/apply?email="
}
