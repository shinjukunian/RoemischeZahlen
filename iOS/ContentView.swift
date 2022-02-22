//
//  ContentView.swift
//  XLII (iOS)
//
//  Created by Morten Bertz on 2022/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    
    @State var showLanguageSelection = false
    @State var showSettings = false
    
    @Environment(\.horizontalSizeClass) var horizontalSize:UserInterfaceSizeClass?
    
    var body: some View {
        content
            .background(Color(uiColor: .secondarySystemBackground))
            .sheet(isPresented: $showSettings, content: {
                SettingsView()
            })
            .onAppear{
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().standardAppearance = appearance
                UINavigationBar.appearance().scrollEdgeAppearance = appearance
            }
    }
    
    @ViewBuilder
    var settingsButton: some View{
        Button(action: {
            showSettings=true
        }, label: {
            Image(systemName: "gearshape.2")
        }).disabled(holder.numericInput == nil)
    }
    
    @ViewBuilder
    var content: some View{
        if horizontalSize == .regular{
            
            HStack{
                Rectangle().frame(width:0).background(.ultraThinMaterial)
                InputView(holder: holder)
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing, content: {
                            settingsButton
                        })
                    }).padding(.top)
                    .edgesIgnoringSafeArea([.bottom])
                Divider().background(Color.accentColor)
                OutputSelectionView(holder: holder)
            }

            
        }
        else{
            InputView(holder: holder)
                .toolbar(content: {
                    
                    ToolbarItemGroup(placement: .bottomBar, content: {
                        Spacer()
                        Button(action: {
                            showLanguageSelection=true
                        }, label: {
                            Image(systemName: "plus.rectangle")
                        }).disabled(holder.numericInput == nil)
                        Spacer()
                        settingsButton
                    })
                    
                })
                .sheet(isPresented: $showLanguageSelection, onDismiss: {}, content: {
                    NavigationView{
                        OutputSelectionView(holder: holder)
                            .navigationTitle(Text("Output Selection"))
                    }
                })
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="m"
        return ContentView(holder: holder)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
