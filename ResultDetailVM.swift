//
//  ResultDetailVM.swift
//  NuGuNa
//
//  Created by 시모니 on 2/7/24.
//

import Foundation

class ResultDetailVM {
    
    let getGPTEndURL = "http://3.34.164.96:8000/debates/summary?BILL_NO="
    
    //MARK: - ⬇️ getGPTEnd 파싱
    struct StatementGPTEndData: Codable {
        let id: Int
        let statementType: String
        let content: String
        let isChatGPT: Bool
        let position: Int

        enum CodingKeys: String, CodingKey {
            case id
            case statementType = "statement_type"
            case content
            case isChatGPT = "is_chatgpt"
            case position
        }
    }

    
}
