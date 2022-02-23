//
//  ContentView.swift
//  Shared
//
//  Created by Miho on 2021/04/29.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    @StateObject var holder=ConversionInputHolder()
    
    @AppStorage(UserDefaults.Keys.showSideBarKey) var showSideBar:Bool = true
    
    var body: some View{
        HSplitView{
            ZStack{
                
                List{}.listStyle(.sidebar)
                InputView(holder: holder)
                    .toolbar(content: {
                        
                    }).frame(minWidth:250, idealWidth: 250, maxWidth: 350)
                    .padding(.top)
                    .edgesIgnoringSafeArea([.bottom])
            }
            
            if showSideBar {
                    OutputSelectionView(holder: holder)
                        .frame(minWidth:200, maxWidth: 400)
                
            }
        }.toolbar(content: {
            ToolbarItem(placement: .status, content: {
                SidebarButton(showSideBar: $showSideBar)
            })
        })
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="m"
        return ContentView(holder: holder)
    }
}



