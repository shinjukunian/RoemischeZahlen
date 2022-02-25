//
//  WidgetView.swift
//  Widget-iOSExtension
//
//  Created by Morten Bertz on 2022/02/25.
//

import SwiftUI
import XLIICore
import WidgetKit

struct WidgetView: View {
    
    let entry:DateEntry
    
    
    var body: some View {
        ZStack{
            Rectangle().fill(Color.primary.opacity(0.1))
            
            if let formatted=entry.formattedDate{
                
                VStack(spacing: 4.0){
                    HStack{
                        Text(verbatim: entry.output.description)
                            .font(.caption2)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }
                    VStack(alignment: .center, spacing: 5){
                        VStack{
                            TimeView(formattedEntry: formatted)
                            Text(entry.date.formatted(date: .omitted, time: .shortened)).font(.caption).foregroundColor(.secondary)
                        }.frame(maxWidth: .infinity).padding(5)
                            .background(content: {
                                RoundedRectangle(cornerRadius: 8).fill(.background)
                            })
                            
                        VStack{
                            DateView(formattedEntry: formatted)
                                .minimumScaleFactor(0.5)
                            Text(entry.date.formatted(date: .numeric, time: .omitted)).font(.caption).foregroundColor(.secondary)
                        }.frame(maxWidth: .infinity).padding(5).background(content: {
                            RoundedRectangle(cornerRadius: 8).fill(.white)
                        })
                        
                        
                    }
                }.padding()
                
                Spacer()
                    
                
            }
            else{
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
            }
        }
        
        
    }
    
    
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let intent=ConfigurationIntent()
        intent.output = .babylonian
        let components=DateComponents(calendar: .autoupdatingCurrent, timeZone: nil, year: 2022, month: 2, day: 22, hour: 19, minute: 10, second: 0)
        
        return WidgetView(entry: .init(date: components.date ?? .now, configuration: intent))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.locale, .init(identifier: "ja_JP"))
    }
}
