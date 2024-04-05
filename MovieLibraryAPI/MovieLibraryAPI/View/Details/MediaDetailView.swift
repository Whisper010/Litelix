//
//  MediaDetailView.swift
//  MovieLibraryAPI
//
//  Created by Linar Zinatullin on 15/11/23.
//

import SwiftUI

struct MediaDetailView: View {
    

    
    @Environment(\.dismiss) var dismiss
    
    
    @State var viewModel = MediaDetailsViewModel()
    
    let media: Media
    let headerHeight: CGFloat = 0.45
    let bodyHeight: CGFloat = 0.32
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        
        ZStack{
            Color.brighten(hex: 0x000000, percentage: 0.05).ignoresSafeArea()
            
            VStack{
                AsyncImage(url: media.backdropURL){ image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame( maxWidth: screenWidth, maxHeight: screenHeight * headerHeight)
                        .clipShape(RoundedRectangle(cornerRadius: 15.0))
                    
                    
                }placeholder: {
                    ProgressView()
                }
                Spacer()
            }
            .ignoresSafeArea()
            
      ScrollView{
                
                VStack(spacing:12){
                    Spacer()
                        .frame(height: screenHeight * bodyHeight)
                    HStack{
                        Text(media.media_type == "movie"  ? media.title ?? "" : media.name ?? "")
                            .font(.title)
                            .fontWeight(.heavy)
                            .shadow(radius: 10)
                        Spacer()
                        //ratings here
                    }
                    HStack{
                        //genre tags
                        
                        //running time
                    }
                    
                    HStack{
                        Text("Overview")
                            .font(.title3)
                            .fontWeight(.bold)
                            .shadow(radius: 10)
                        Spacer()
                        //see all button
                    }
                    
                    Text(media.overview)
                        .foregroundColor(.secondary)
                    
                    HStack{
                        
                        Text("Cast & Crew")
                            .font(.title3)
                            .fontWeight(.bold)
                            .shadow(radius: 10)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        LazyHStack{
                            ForEach(viewModel.profiles){profile in
                                CastView(castProfile: profile)
                            }
                            
                        }
                    }
                    
                    
                }.padding()
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar{
            ToolbarItem(placement: .navigationBarLeading){
                Button {
                    dismiss()
                }label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .fontWeight(.bold)
                }
            }
        }
        .task{
            await viewModel.movieCredits(for: media.id )
            await viewModel.loadCastProfiles()
        }
        
        
    }
    
}

#Preview {
    MediaDetailView(media: MediaViewModel.preview)
}


struct CastView: View {
    
    let castProfile: CastProfile
    
    var body: some View{
        VStack{
           
            AsyncImage(url: castProfile.photoURL){image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15.0))
            }placeholder: {
                ProgressView()
                    .frame(width: 150, height: 180)
            }
            
            Text(castProfile.name)
                .fontWeight(.bold)
                .frame(maxWidth: 150,alignment: .center)
                .truncationMode(.tail)
            
                
           
        }

    }
}
