import SwiftUI


struct ViewOffsetKey: PreferenceKey{
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        withAnimation{
            value += nextValue()
        }
        
    }
}

class GradientViewModel: ObservableObject{
    
    
    @Published var gradientFactor: Double = 0.5
    private let scrollTreshold: Double = UIScreen.main.bounds.height * 0.2
    
    // Function to adjust gradient factor smoothly based on scroll offset
    func adjustGradientFactor(for offset: CGFloat){
        
        if abs(offset) > scrollTreshold{
            
            let adjustedOffset = abs(offset) - scrollTreshold
            
            let directionFactor = offset > 0 ? -1 : 1
            
            let newFactor = max(0.0, min(1.0, 0.35 - Double(directionFactor) * adjustedOffset / 1000))
            withAnimation(.easeInOut){
                gradientFactor = newFactor
            }
            
            
        }
        
        
    }
}

struct HomeView: View {
    
    @StateObject var viewModel = MediaViewModel()
    
    @StateObject var gradientViewModel = GradientViewModel()
    
    @State var gradientFactor = 0.5
    
    @State var searchText = ""
    
    @State var mainMedia: Media? = nil
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                ScrollView(showsIndicators: false){
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ViewOffsetKey.self, value: geometry.frame(in: .named("ScroolView")).origin.y)
                            .frame(width: 0,height: 0)
                        
                    }
                    .frame(width: 0, height: 0)
                    
                    if searchText.isEmpty{
                        VStack{
                            RecommendationPoster(media: viewModel.airingTVs.last)
                                
                                
                            MovieListView(collection: $viewModel.trendingTVs, titleText: "Trending TV Shows")
                            MovieListView(collection: $viewModel.trendingMovies, titleText: "Trending Movies")
                            
                            MovieListView(collection: $viewModel.ratedTVs, titleText: "Top TV Shows")
                            MovieListView(collection: $viewModel.ratedMovies, titleText: "Top Movies")
                            
                            MovieListView(collection: $viewModel.popularTVs, titleText: "Popular TV Shows")
                            MovieListView(collection: $viewModel.popularMovies, titleText: "Popular Movies")
                            
                        }
                        
                        
                    }else {
                        LazyVStack{
                            ForEach(viewModel.searchResults) { item in
                                NavigationLink(destination: MediaDetailView(media: item)){
                                    HStack{
                                        AsyncImage(url: item.posterThumbnail){ image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80,height: 120)
                                            
                                        }placeholder: {
                                            ProgressView()
                                                .frame(width: 80,height: 120)
                                        }
                                        .clipped()
                                        .cornerRadius(10.0)
                                        VStack(alignment: .leading){
                                            
                                            Text(item.titleName)
                                                .foregroundColor(.white)
                                                .fontWeight(.heavy)
                                                .font(.headline)
                                            
                                            HStack{
                                                Image(systemName: "hand.thumbsup.fill")
                                                Text("\(item.vote_average, specifier: "%.1f")" )
                                                Spacer()
                                            }
                                            .foregroundColor(Color.brighten(hex: 0xCD2F26,percentage: 0.3))
                                            .fontWeight(.heavy)
                                        }.padding()
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal)
                                }
                            }
                        }
                    }
                    
                }
                .coordinateSpace(name: "ScrollView")
                .onPreferenceChange(ViewOffsetKey.self){ value in
                    gradientViewModel.adjustGradientFactor(for: value)
                }
                
            }
            .accessibilityLabel("Navigated to Home Screen")
            
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Text("For You")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .padding()
                    
                }
            }
            
            .background(
                LinearGradient(colors: [Color(hex: 0x0DD3F3, alpha: gradientViewModel.gradientFactor), .black], startPoint: .top, endPoint: .bottom)
            )
        }
        .onChange(of: searchText){ newValue in
            if newValue.count > 0{
                Task{
                    await viewModel.search(term: searchText)
                }
                
            }
        }
        
        
        .searchable(text: $searchText)
        
        .onAppear{
            Task{
                await viewModel.loadTrending(mediaType: .movie)
                await viewModel.loadTrending(mediaType: .tv)
                
                await viewModel.loadRated(mediaType: .movie)
                await viewModel.loadRated(mediaType: .tv)
                
                await viewModel.loadPopular(mediaType: .movie)
                await viewModel.loadPopular(mediaType: .tv)
                
                await viewModel.loadAiringTVs()
                
                await viewModel.loadGenres(mediaType: .movie)
                await viewModel.loadGenres(mediaType: .tv)
            }
            mainMedia = viewModel.airingTVs.first
            
        }
        
    }
}

struct RoundedButtonStyle: ButtonStyle {
    
    var backgroundColor: Color
    var rectOpacity: Double = 1.0
    
    let screenSize = UIScreen.main.bounds.size
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            
            .background(RoundedRectangle(cornerRadius: 10.0).fill( backgroundColor).opacity(rectOpacity))
            .shadow(radius: 5) // Optional: add shadow for a lifted effect
            .frame(width: screenSize.width * 0.35 ,height: screenSize.height * 0.05)
            
    }
}


#Preview {
    HomeView()
}
