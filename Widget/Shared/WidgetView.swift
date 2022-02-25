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
            Rectangle().fill(Color.widgetBackground)
            
            if let formatted=entry.formattedDate{
                
                VStack(spacing: 4){
                    HStack{
                        Text(verbatim: entry.output.description)
                            .font(.caption2)
                            
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                    VStack(alignment: .center){
                        timeStack(formatted: formatted)
                        dateStack(formatted: formatted)
                    }
                }.padding(6)
    
            }
            else{
                Text(entry.date.formatted(date: .abbreviated, time: .shortened))
                    .multilineTextAlignment(.center)
                    .font(.headline)
                
            }
        }
        .widgetURL(entry.deepLinkURL)
    }
    
    @ViewBuilder
    func timeStack(formatted:FormattedDate)-> some View{
        VStack{
            TimeView(formattedEntry: formatted)
                .font(.title2)
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.1)
            if entry.showDate{
                Text(entry.date.formatted(date: .omitted, time: .shortened)).font(.caption).foregroundColor(.secondary)
            }
            
        }.frame(maxWidth: .infinity).padding(5)
            .background(content: {
                RoundedRectangle(cornerRadius: 8).fill(.background)
            })
    }
    
    @ViewBuilder
    func dateStack(formatted:FormattedDate)-> some View{
        VStack{
            DateView(formattedEntry: formatted)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
                .multilineTextAlignment(.center)
            if entry.showDate{
                Text(entry.date.formatted(date: .numeric, time: .omitted)).font(.caption).foregroundColor(.secondary)
            }
        }.frame(maxWidth: .infinity).padding(5).background(content: {
            RoundedRectangle(cornerRadius: 8).fill(.background
            )
        })
    }
    
    
}

struct WidgetView_Previews: PreviewProvider {
    static var previews: some View {
        let intent=ConfigurationIntent()
        intent.output = .aegean
        let components=DateComponents(calendar: .autoupdatingCurrent, timeZone: nil, year: 2022, month: 12, day: 19, hour: 23, minute: 50, second: 0)
        
        return WidgetView(entry: .init(date: components.date ?? .now, configuration: intent))
            .preferredColorScheme(.dark)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .environment(\.locale, .init(identifier: "de_DE"))
    }
}
