//
//  ConversionTableView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import SwiftUI
import XLIICore

struct ConversionTableView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    let displayItems:[Output]
    @State var draggedItem:Output? = nil
    
    let selectedConversion:NumericParsingResult
    
    var body: some View {
        ScrollView{
            ForEach(displayItems, content: {outPut in
                let hh=NumeralConversionHolder(info: NumeralConversionHolder.ConversionInfo(input: selectedConversion.value, outputMode: outPut))
                
                NumericalConversionView(holder: hh)
                    .onDrag({
                        let provider=NSItemProvider(item: nil, typeIdentifier: Output.dragType)
                        provider.registerObject(hh.formattedOutput as NSString, visibility: .all)
                        
                        draggedItem = outPut
                        return provider
                    })
                    .onDrop(of: [Output.dragType], delegate: ContentViewReorderDropDelegate(item:outPut, items: $holder.outputs, draggedItem: $draggedItem))
                    .contextMenu(menuItems: {
                        Button(action: {
                            hh.speak()
                        }, label: {
                            Label(title: {Text("Speak")}, icon: {Image(systemName: "play.rectangle.fill")})
                        })
                        
                        copyButtons(holder: hh)
                        
                        if holder.outputs.contains(outPut){
                            Button(role: .destructive, action: {
                                withAnimation(.default) {
                                    guard let holderIDX=holder.outputs.firstIndex(of: outPut)
                                            else{return}
                                    holder.outputs.remove(at: holderIDX)
                                }
                            }, label: {
                                Label(title: {Text("Remove")}, icon: {Image(systemName: "trash")})
                            })

                        }
                        
                    })
                    
            })
        }
    }
    
    @ViewBuilder
    func copyButtons(holder: NumeralConversionHolder) -> some View{
        switch holder.info.outputMode{
        case .arabisch:
            Button(action: {
#if os(macOS)
                NSPasteboard.general.declareTypes([.string], owner: nil)
                NSPasteboard.general.setString(holder.formattedOutput, forType: .string)
#else
                UIPasteboard.general.string=holder.formattedOutput
#endif
                
            }, label: {Label(title: {Text("Copy")}, icon: {Image(systemName: "arrow.right.doc.on.clipboard")})})
            Button(action: {
#if os(macOS)
                NSPasteboard.general.declareTypes([.string], owner: nil)
                NSPasteboard.general.setString(String(holder.info.input), forType: .string)
#else
                UIPasteboard.general.string=String(holder.info.input)
#endif
                
            }, label: {Label(title: {Text("Copy Unformatted")}, icon: {Image(systemName: "arrow.right.doc.on.clipboard")})})
        default:
            Button(action: {
#if os(macOS)
                NSPasteboard.general.declareTypes([.string], owner: nil)
                NSPasteboard.general.setString(holder.formattedOutput, forType: .string)
#else
                UIPasteboard.general.string=holder.formattedOutput
#endif
                
            }, label: {Label(title: {Text("Copy")}, icon: {Image(systemName: "arrow.right.doc.on.clipboard")})})
        }
    }
}

struct ConversionTableView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input=""
        
        return ConversionTableView(holder: holder,
                                   displayItems: [.currentLocale, .localized(locale: Locale(identifier: "el_GR"))],
                                   selectedConversion: holder.results.first ?? .empty)
        
    }
}


struct ContentViewReorderDropDelegate:DropDelegate{
    //https://avitsadok.medium.com/reorder-items-in-swiftui-lazyvstack-6d238efab04
    let item:Output
    @Binding var items:[Output]
    @Binding var draggedItem:Output?
    
    func performDrop(info: DropInfo) -> Bool {
        return true
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        guard let draggedItem = self.draggedItem,
              items.contains(item),
              items.contains(draggedItem) else {
                  return DropProposal(operation: .forbidden)
        }
        return DropProposal(operation: .move)
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = self.draggedItem,
              items.contains(draggedItem) else {
                  return
              }
        if draggedItem != item,
           let from = items.firstIndex(of: draggedItem),
           let to = items.firstIndex(of: item){
            
            withAnimation(.default) {
                self.items.move(fromOffsets: IndexSet(integer: from), toOffset: to > from ? to + 1 : to)
            }
        }
    }
}
