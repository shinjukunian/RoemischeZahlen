//
//  ConversionDetailResultView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/03/04.
//

import SwiftUI

struct ConversionDetailResultView: View {
    @EnvironmentObject var holder:ConversionDetailHolder

    var body: some View {
        switch holder.state{
        case .converted:
            Group{
                HStack{
                    Spacer()
                    Text(holder.formattedConvertedOutput)
                        .multilineTextAlignment(.center)
                        .contextMenu(menuItems: {
                            Button(action: {
                                Pasteboard.general.add(text: holder.formattedConvertedOutput)
                            }, label: {
                                Label(title: {Text("Copy")}, icon: {
                                    Image(systemName: "arrow.right.doc.on.clipboard")
                                    
                                })
                            })
                        })
                    Text("=").foregroundColor(.accentColor)
                    Text(holder.formattedNumericOutput)
                    Spacer()
                }
            }.font(.title)
                
        case .empty:
            Text("Please enter a number")
        case .invalid:
            Text("The input **\(holder.textualInput)** could not be converted")
        }
    }
}

struct ConversionDetailResultView_Previews: PreviewProvider {
    static var previews: some View {
        ConversionDetailResultView()
    }
}
