//
//  AgreeChatVM.swift
//  NuGuNa
//
//  Created by 시모니 on 2/6/24.
//

import Foundation

class AgreeChatVM {
    
    let postLeftURL = "http://3.34.164.96:8000/debates/statement?BILL_NO="
    let postMidURL = "&position=0" // 반대는 1
    let postRightURL = "&type="
    var qType: Int = 0
    
    let getLeftURL = "http://3.34.164.96:8000/debates/statement?BILL_NO="
    let getRightURL = "&position=0"// 반대는 1
    
    
    let postGPTLeftURL = "http://3.34.164.96:8000/debates/summary?BILL_NO="
    let postGPTLMidURL = "&position=0"// 반대는 1
    let postGPTRightURL = "&type="
    
    
    
    
    
   
    
    //MARK: - ⬇️ PostGPT 파싱
    struct StatementGPTData: Codable {
        let id: Int
        let statementType: String
        let position: String
        let content: String
        let isChatGPT: Bool

        enum CodingKeys: String, CodingKey {
            case id
            case statementType = "statement_type"
            case position
            case content
            case isChatGPT = "is_chatgpt"
        }
    }
    
    //MARK: - ⬇️ Post 파싱
    struct StatementData: Codable {
        let statementId: Int
        let content: String
        let isChatGPT: Bool
        let email: String
        let statementType: String

        enum CodingKeys: String, CodingKey {
            case statementId = "statement_id"
            case content
            case isChatGPT = "is_chatgpt"
            case email
            case statementType = "statement_type"
        }
    }
    
    //MARK: - ⬇️ get 파싱
    struct ContentData: Codable {
        let id: Int
        let content: String
        let isChatGPT: Bool
        let email: String

        enum CodingKeys: String, CodingKey {
            case id
            case content
            case isChatGPT = "is_chatgpt"
            case email
        }
    }
    
}
