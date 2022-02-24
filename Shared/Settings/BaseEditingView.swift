//
//  BaseEditingView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/24.
//

import Foundation
import SwiftUI
import XLIICore

struct BaseEditingView:View{
    
    @State var editingDone:(Int)->Void = {_ in }
    @State var base:Int
    
    let invalidBases:[Int]
    
    var body: some View{
        VStack{
            Text(verbatim:Output.numeric(base: base).description)
            let binding=Binding(get: {
                return Double(base)
            }, set: {new in
                base=Int(new)
            })
            Slider(value: binding, in: 2...36, step: 1, label: {}, minimumValueLabel: {
                Text(verbatim: "2")
            }, maximumValueLabel: {
                Text(verbatim: "36")
            }).padding(.horizontal)
            
            Button(action: {
                editingDone(base)
            }, label: {
                Text("Done")
            }).disabled(invalidBases.contains(base) || base == 10)
        }
    }
}

struct BaseEditingView_Previews: PreviewProvider{
    static var previews: some View {
        BaseEditingView(base: 12, invalidBases: [8,7,19])
    }
}
