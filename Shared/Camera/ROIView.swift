//
//  ROIView.swift
//  RoemischeZahl
//
//  Created by Morten Bertz on 2021/05/04.
//

import SwiftUI

struct ROIView: View {
    
    @State var roiRect:CGRect
    
    var body: some View {
        GeometryReader(content: { geometry in
            Color.black.opacity(0.2).clipShape(Path{path in
                
                path.addPath(Rectangle().path(in: CGRect(origin: .zero, size: geometry.size)))
                path.addPath(Path.init(roundedRect: CGRect(x: (geometry.size.width - roiRect.width * geometry.size.width)/2, y: geometry.size.height - geometry.size.height * roiRect.maxY, width: roiRect.width * geometry.size.width, height: roiRect.height * geometry.size.height), cornerRadius: 10))
            }
            , style: .init(eoFill: true, antialiased: true))
        })
    }
}

struct ROIView_Previews: PreviewProvider {
    static var previews: some View {
        ROIView(roiRect: CGRect(x: 0.25, y: 0.7, width: 0.5, height: 0.2))
   }
}
