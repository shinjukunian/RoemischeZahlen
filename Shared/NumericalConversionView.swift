//
//  NumericalConversionView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/20.
//

import SwiftUI
import XLIICore

struct NumericalConversionView: View {
    
    let holder:NumeralConversionHolder
    @State var isHovering:Bool = false
    @State var isHoveringOnButton = false
    
    let isSelected:Bool
    
    var body: some View {
        GroupBox{
            VStack{
                HStack{
                    Text(verbatim: holder.output.description)
                        .font(.caption2)
                    if holder.output.buttons != nil{
                        Image(systemName: "info.circle")
                    }
                    Spacer()
                    HStack{
                        
                        if let url=holder.output.url{
                            Link(destination: url, label: {
                                Image(systemName: "safari")
                            })
                        }
                        
                        Button(action: {
                            holder.speak()
                        }, label: {
                            if isHoveringOnButton{
                                Image(systemName: "play.fill")
                            }
                            else{
                                Image(systemName: "play")
                            }
                            
                        })
                            .help(Text("Speak"))
                            .buttonStyle(.borderless)
                            .onHover(perform: {h in
                                isHoveringOnButton=h
                            })
                    }
                }
                
                Divider()
                Text(holder.formattedOutput)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .lineLimit(6)
                
            }
        }.groupBoxStyle(ConversionCardBoxStyle(isHovering: isSelected))

    }
}

struct NumericalConversionView_Previews: PreviewProvider {
    static var previews: some View {
        NumericalConversionView(holder: .init(input: 42, output: .hieroglyph, originalText: "42"), isSelected: true)
    }
}




struct ConversionCardBoxStyle: GroupBoxStyle {
    
    let isHovering:Bool
    
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
#if os(iOS)
        .background(Color(uiColor: .secondarySystemGroupedBackground))
#else
        .background(Color.init(nsColor: .controlBackgroundColor))
#endif
        .overlay(content:{
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(Color.accentColor, lineWidth: isHovering ? 3 : 0)
            
        })
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        
        
        
    }
}
