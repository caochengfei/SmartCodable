//
//  Test2ViewController.swift
//  SmartCodable_Example
//
//  Created by qixin on 2024/4/10.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import Foundation
import SmartCodable
import HandyJSON


class Test2ViewController: BaseViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arr = ["1", "2"]
        let dict: [String: Any] = [
            "models": arr
            
//            "models": [
//                [
//                    "name": 10
//                ]
//            ]

        ]
        
        
        let value = dict.decode(type: Model.self)
        print(value)
        
        // typeMismatch(Swift.Int, Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "models", intValue: nil), _JSONKey(stringValue: "Index 0", intValue: 0)], debugDescription: "Expected to decode Int but found a string instead.", underlyingError: nil))
        return
//        if let jsonObject = Model.deserialize(from: dict) {
//            print(jsonObject)
//        }
    }
    

    
    struct Model: SmartCodable {
        init() {
            
        }
        
        var models: [Int] = []

//        var models: [SubModel] = [SubModel()]
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            
            var unkeyedContainer = try container.nestedUnkeyedContainer(forKey: .models)

            let first = try unkeyedContainer.decode(Int.self)
            let second = try unkeyedContainer.decode(Int.self)
            
            self.models = [first, second]
            
        }
    }
    
    struct SubModel: SmartCodable {
        var name: Int = 123
    }
}

