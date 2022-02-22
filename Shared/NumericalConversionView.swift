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
                    .help(Text("Speak"))
                    .buttonStyle(.borderless)
                }
                
                Divider()
                Text(holder.formattedOutput)
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .lineLimit(6)
                    
            }
        }.groupBoxStyle(ConversionCardBoxStyle())
        
        
        
            
    }
}

struct NumericalConversionView_Previews: PreviewProvider {
    static var previews: some View {
        NumericalConversionView(holder: NumeralConversionHolder(info: NumeralConversionHolder.ConversionInfo(input: 4, outputMode: .sangi)))
    }
}




struct ConversionCardBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        #if os(iOS)
        .background(Color(uiColor: .systemBackground))
        #else
        .background(Color.init(nsColor: .controlBackgroundColor))
        #endif
        
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
