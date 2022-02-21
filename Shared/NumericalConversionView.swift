//
//  NumericalConversionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import SwiftUI

struct NumericalConversionView: View {
    
    let holder:NumeralConversionHolder
    
    var body: some View {
        GroupBox{
            VStack{
                HStack{
                    Text(verbatim: holder.info.outputMode.description)
                        .font(.caption2)
                    Spacer()
                    Button(action: {
                        holder.speak()
                    }, label: {
                        Image(systemName: "play")
                    })
                    .keyboardShortcut(KeyEquivalent("s"), modifiers: [.command,.option])
                    .help(Text("Speak"))
                }
                
                Divider()
                Text(holder.formattedOutput)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .lineLimit(6)
                    
            }
        }
        .padding(.horizontal)
        
        
            
    }
}

struct NumericalConversionView_Previews: PreviewProvider {
    static var previews: some View {
        NumericalConversionView(holder: NumeralConversionHolder(info: NumeralConversionHolder.ConversionInfo(input: 42, outputMode: .sangi)))
    }
}
