//
//  OutputView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import SwiftUI

struct OutputView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    @State var selectedBase:ConversionInputHolder.InputType.Base = .decimal

    var body: some View {
        contentView
            
            .onChange(of: holder.inputType, perform: {input in
                switch input{
                case .numeric(let results):
                    self.selectedBase =  (results.first(where: {$0.base == holder.preferredBase})?.base ?? results.first?.base) ?? .decimal
                default:
                    break
                }
            })
            .onChange(of: selectedBase, perform: {selectedBase in
                switch holder.inputType{
                case .numeric(let results):
                    guard let result=results.first(where: {$0.base == selectedBase}) else{
                        return
                    }
                    holder.numericInput = result.value
                default: break
                }
            })
        
    }
    
    @ViewBuilder
    var contentView: some View{
        switch holder.inputType{
        case .empty:
            Divider().background(Color.accentColor)
            GroupBox{
                Text("Please enter a number")
            }
        case .invalid:
            Divider().background(Color.accentColor)
            GroupBox{
                Text("The input could not be parsed.")
            }
        case .overflow:
            Divider().background(Color.accentColor)
            GroupBox{
                Text("The input is too large to be represented.")
            }
        case .textual(let output):
            Text(verbatim: output.description).font(.caption2)
            Divider().background(Color.accentColor)
            let validOutputs=holder.outputs.filter({$0 != output})
            let items=[Output.arabisch, Output.currentLocale] + validOutputs
            ConversionTableView(holder: holder, displayItems: items)
        case .arabic:
            Divider().background(Color.accentColor)
            let items=[Output.currentLocale] + holder.outputs
            
            ConversionTableView(holder: holder, displayItems: items)
        case .numeric(let results):
            if results.count > 1{
                Picker(selection: $selectedBase, content: {
                    ForEach(results.map{$0.base}, id: \.self, content: {base in
                        Text(verbatim: Output.numeric(base: base.rawValue).description).tag(base)
                    })
                }, label: {})
                .pickerStyle(.segmented)
            
            }
            else{
                let output=Output.numeric(base: results.first?.base.rawValue ?? 10)
                Text(verbatim: output.description).font(.caption2)
            }
            
            Divider().background(Color.accentColor)
            let items:[Output] = {
                let items:[Output]
                if selectedBase == .decimal{
                    items = [Output.currentLocale] +  holder.outputs
                }
                else{
                    items = [.arabisch, Output.currentLocale] +  holder.outputs
                }
                return items.filter({output in
                    switch output{
                    case .numeric(let base):
                        return base != selectedBase.rawValue
                    default: return true
                    }
                })
            }()
            ConversionTableView(holder: holder, displayItems: items)
        }
    }
}

struct OutputView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input="10"
        return ContentView(holder: holder)
    }
}
