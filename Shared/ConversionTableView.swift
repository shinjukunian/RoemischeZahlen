//
//  ConversionTableView.swift
//  XLII
//
//  Created by Morten Bertz on 2022/02/21.
//

import SwiftUI

struct ConversionTableView: View {
    
    @ObservedObject var holder:ConversionInputHolder
    let displayItems:[Output]
    @State var draggedItem:Output? = nil
    
    var body: some View {
        if let input=holder.numericInput {
            ScrollView{
                ForEach(displayItems, content: {outPut in
                    let hh=NumeralConversionHolder(info: NumeralConversionHolder.ConversionInfo(input: input, outputMode: outPut))
                    
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
                            Button(action: {
                                    #if os(macOS)
                                    NSPasteboard.general.declareTypes([.string], owner: nil)
                                    NSPasteboard.general.setString(hh.formattedOutput, forType: .string)
                                    #else
                                    UIPasteboard.general.string=hh.formattedOutput
                                    #endif
                                
                            }, label: {Label(title: {Text("Copy")}, icon: {Image(systemName: "arrow.right.doc.on.clipboard")})})
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
        else{
            EmptyView()
        }
        
        
    }
}

struct ConversionTableView_Previews: PreviewProvider {
    static var previews: some View {
        let holder=ConversionInputHolder()
        holder.input=""
        return ConversionTableView(holder: holder, displayItems:  [.currentLocale, .localized(locale: Locale(identifier: "el_GR"))] + holder.outputs)
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
