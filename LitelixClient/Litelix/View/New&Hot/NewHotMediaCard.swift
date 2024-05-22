//
//  UpcommingMediaCard.swift
//  Litelix
//
//  Created by Linar Zinatullin on 21/11/23.
//

import SwiftUI




struct NewHotMediaCard: View {
    
    let media: Media
    
    let category: Categories
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var heightFactor: Double = 0
    var widthFactor : Double = 0
    
    @State var topIndex: Int
    
    init(media: Media, category: Categories, topIndex: Int = 0) {
        self.media = media
        self.category = category
        
        var widthFactor : Double {
            
            let aspectRatio = Double(screenHeight/screenWidth)
            if aspectRatio >= 19.0/9 && aspectRatio <= 19.6/9{
                
                return category == .everyoneWatching ? 0.9 : 0.85
            }else if aspectRatio >= 15.0/9 && aspectRatio <= 17.0/9{
                return category == .everyoneWatching ? 0.9 : 0.8
            }
            return category == .everyoneWatching ? 0.95 : 0.92
        }
        var heightFactor: Double {
            let aspectRatio = Double(screenHeight/screenWidth)
            if aspectRatio >= 19.0/9 && aspectRatio <= 19.6/9{
                return category == .everyoneWatching ? 0.23 : 0.22
            }else if aspectRatio >= 15.0/9 && aspectRatio <= 17.0/9{
                return category == .everyoneWatching ? 0.3 : 0.25
            }
            return category == .everyoneWatching ? 0.4 : 0.35
        }
        self.topIndex = topIndex
        
        self.heightFactor = heightFactor
        self.widthFactor = widthFactor
        
        
        
    }
    
    var body: some View {
        HStack{
            
            
            
            VStack{
                if category == .comingSoon {
                    Text(self.getMonthName(from: media.release_date, isTitle: true))
                        .font(.title3)
                        .fontWeight(.medium)
                        
                    Text(self.extractDay(from: media.release_date))
                        .multilineTextAlignment(.trailing)
                        .font(.title)
                        .fontWeight(.heavy)
                    
                }else if category != .everyoneWatching {
                    Text(String(topIndex))
                        .font(.title)
                        .fontWeight(.heavy)
                        
                }
                
               
                Spacer()
            }
           
            VStack{
                ZStack{
                    
                    
                    AsyncImage(url: media.backdropURL){ image in
                        image
                            .resizable()
                            .frame(width:screenWidth * widthFactor ,height: screenHeight * heightFactor)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 10.0))
                           
                    } placeholder: {
                        ZStack{
                            Rectangle().fill(Color.gray)
                                .frame(width: screenWidth * widthFactor,height: screenHeight * heightFactor)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                            ProgressView()
                                .frame(width: screenWidth * widthFactor,height: screenHeight * heightFactor)
                            
                        }
                        
                    }
                    VStack(){
                        HStack{
                            Text("L")
                                    .foregroundStyle(Color(hex: 0xD22F27))
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    
                                Spacer()
                                
                        }
                        Spacer()
                    }.padding()
                   
                    
                    
                }
                
                HStack{
                    HStack{
                        Text("L")
                            .foregroundStyle(Color(hex: 0xD22F27))
                            .font(.title3)
                            .fontWeight(.heavy)
                        Text("MEDIA")
                            .foregroundStyle(.secondary)
                            .font(.footnote)
                        
                        Spacer()
                        
                    }
                    Text("")
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        VStack{
                            Image(systemName: "bell")
                                .fontWeight(.bold)
                            
                            Text("Remind Me")
                                .font(.footnote)
                        }.tint(.white)
                    }).padding(.trailing)
                    
                    NavigationLink(destination: MediaDetailView(media: media)){
                        
                        VStack{
                            Image(systemName: "info.circle")
                            Text("Info")
                                .font(.footnote)
                        }.tint(.white)
                        
                    }
                    
                }.padding( [.top,.trailing])
                if category == .comingSoon{
                    HStack{
                        Text("Coming " + getMonthName(from: media.release_date) + " " + extractDay(from: media.release_date))
                        Spacer()
                    }
                }
                
               
                
                HStack{
                    Text(media.titleName)
                        .font(.title2)
                        .fontWeight(.heavy)
                    Spacer()
                }
                
                HStack{
                    Text(media.overview)
                        .font(.footnote)
                        .lineLimit(3)
                    Spacer()
                }
            }
            
        }.padding()
    }
    private func extractDay(from dateStr: String?, withZeroLeading: Bool = false) -> String{
        guard let dateStr = dateStr else {return ""}
        let startIndex = dateStr.index(dateStr.endIndex, offsetBy: -2)
        let returnString = withZeroLeading ? String(dateStr[startIndex...]) : String(dateStr[startIndex...]).trimmingCharacters(in: CharacterSet(charactersIn: "0"))
        return returnString
    }
    
    private func extractMonth(from dateStr: String?) -> String{
        guard let dateStr = dateStr else {return ""}
        
        let startIndex = dateStr.index(dateStr.startIndex, offsetBy: 5)
        let endIndex = dateStr.index(startIndex, offsetBy: 1)
        return String(dateStr[startIndex...endIndex])
    }
    
    private func getMonthName(from dateStr: String?, isTitle: Bool = false) -> String{
        guard let dateStr = dateStr else {return ""}
        
        let startIndex = dateStr.index(dateStr.startIndex, offsetBy: 5)
        let endIndex = dateStr.index(startIndex, offsetBy: 1)
        let extractedMonth = String(dateStr[startIndex...endIndex])
        
        let monthNames = getMonthDictionary(isTitle: isTitle)
        
        
        
        return monthNames[extractedMonth] ?? ""
    }
    
    func getMonthDictionary(isTitle: Bool) -> [String: String] {
        if isTitle {
            return [
                    "01": "JAN",
                    "02": "FEB",
                    "03": "MAR",
                    "04": "APR",
                    "05": "MAY",
                    "06": "JUN",
                    "07": "JUL",
                    "08": "AUG",
                    "09": "SEP",
                    "10": "OCT",
                    "11": "NOV",
                    "12": "DEC"
                ]
        }
        return [
            "01": "January",
            "02": "February",
            "03": "March",
            "04": "April",
            "05": "May",
            "06": "June",
            "07": "July",
            "08": "August",
            "09": "September",
            "10": "October",
            "11": "November",
            "12": "December"
        ]
    }
}

struct UpcommingMediaCard_Previews: PreviewProvider {
    static var previews: some View {
        NewHotMediaCard(media: MediaViewModel.preview, category: .comingSoon)
    }
}

