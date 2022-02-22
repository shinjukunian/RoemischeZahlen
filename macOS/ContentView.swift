//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject var holder:ConversionInputHolder
    
    var body: some View{
        HSplitView{
            InputView(holder: holder)
                .toolbar(content: {
                    
                }).frame(minWidth:200)
                .padding(.top)
                .edgesIgnoringSafeArea([.bottom])
            
            OutputSelectionView(holder: holder)
                .frame(minWidth:200)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="m"
        return ContentView(holder: holder)
    }
}



