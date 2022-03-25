//
//  HistoryItem.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/25.
//

import Foundation

struct HistoryItem:Equatable,Identifiable,Hashable,Codable{
   
    let text:String
    let date:Date
    
    init(text:String, date:Date = Date()){
        self.text=text
        self.date=date
    }
    
    var id: String{
        return text
    }
}

struct HistoryPreference: Equatable,Hashable, RawRepresentable{
    
    typealias RawValue = Data
    
    let items:[HistoryItem]
    
    init(items:[HistoryItem]){
        self.items=items
    }
    
    init?(rawValue: Data) {
        do{
            let items=try JSONDecoder().decode([HistoryItem].self, from: rawValue)
            self.items=items.sorted(by: {$0.date < $1.date})
        }
        catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
    
    var rawValue: Data{
        return (try? JSONEncoder().encode(items)) ?? Data()
    }
    
    static func updateHistory(history:HistoryPreference, items:[HistoryItem])->HistoryPreference{
        let combined=history.items + items
        let uniqued=combined.uniqued(on: {$0.text})
        return HistoryPreference(items: uniqued)
    }
    
    static let empty = HistoryPreference(items: [HistoryItem]())
}
