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
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .contextMenu(menuItems: {
                        Button(action: {
                            holder.speak()
                        }, label: {
                            Label(title: {Text("Speak")}, icon: {Image(systemName: "play.rectangle.fill")})
                        })
                        Button(action: {
                                #if os(macOS)
                                NSPasteboard.general.declareTypes([.string], owner: nil)
                                NSPasteboard.general.setString(holder.formattedOutput, forType: .string)
                                #else
                                UIPasteboard.general.string=holder.formattedOutput
                                #endif
                            
                        }, label: {Label(title: {Text("Copy")}, icon: {Image(systemName: "arrow.right.doc.on.clipboard")})})
                    })
            }
        }
        .padding(.horizontal)
        
            
    }
}

struct NumericalConversionView_Previews: PreviewProvider {
    static var previews: some View {
        NumericalConversionView(holder: NumeralConversionHolder(info: NumeralConversionHolder.ConversionInfo(input: 42, outputMode: .römisch)))
    }
}
