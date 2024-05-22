//
//  PageControl.swift
//  Litelix
//
//  Created by Linar Zinatullin on 25/04/24.
//

import Foundation
import SwiftUI

struct PageControl: View{
    var numberOfPages: Int
    
    @Binding var currentPage: Int
    
    var body: some View{
        HStack{
            ForEach((0..<numberOfPages), id: \.self){ page in
                Circle()
                    .frame(width: 8,height: 8)
                    .foregroundColor(page == currentPage ? Color(hex: 0x315771) : .gray)
                
            }
        }
    }
}
