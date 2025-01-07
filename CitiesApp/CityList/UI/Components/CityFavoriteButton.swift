import SwiftUI

struct CityFavoriteButton: View {
    @State private var isFavorite: Bool
    let action: (Bool) -> Void
    
    init(isFavorite: Bool, action: @escaping (Bool) -> Void) {
        _isFavorite = State(initialValue: isFavorite)
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            isFavorite.toggle()
            action(isFavorite)
        }) {
            Image(systemName: isFavorite ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal)
    }
} 
