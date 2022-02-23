//
//  ContentView.swift
//  XLII (iOS)
//
//  Created by Morten Bertz on 2022/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var holder=ConversionInputHolder()
    
    @State var showLanguageSelection = false
    @State var showSettings = false
    
    @Environment(\.horizontalSizeClass) var horizontalSize:UserInterfaceSizeClass?
    
    @AppStorage(UserDefaults.Keys.showSideBarKey) var showSideBar:Bool = true
    
    var body: some View {
        content
            .background(Color(uiColor: .systemGroupedBackground))
            .toolbar(content: {
                
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if horizontalSize == .regular{
                        SidebarButton(showSideBar: $showSideBar)
                    }
                    else{
                        EmptyView()
                    }
                })
                
            })
            .sheet(isPresented: $showSettings, content: {
                NavigationView{
                    SettingsView()  
                }
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
            Label(title: {Text("Show Settings")}, icon: {Image(systemName: "gearshape.2")})
        })//.disabled(holder.numericInput == nil)
    }
    
    @ViewBuilder
    var content: some View{
        if horizontalSize == .regular && showSideBar == true{
            
            HStack{
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
                .padding(.top)
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
            .previewInterfaceOrientation(.landscapeRight)
    }
}
