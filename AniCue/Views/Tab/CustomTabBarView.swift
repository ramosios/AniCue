import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedTab: Tab

    enum Tab: Int, CaseIterable {
        case discover, watchlist, games, profile

        var iconName: String {
            switch self {
            case .discover: return "sparkles"
            case .watchlist: return "heart.fill"
            case .games: return "gamecontroller"
            case .profile: return "person.crop.circle"
            }
        }

        var title: String {
            switch self {
            case .discover: return "Discover"
            case .watchlist: return "Watchlist"
            case .games: return "Games"
            case .profile: return "Profile"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Spacer()
                Button(action: {
                    selectedTab = tab
                }, label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.iconName)
                            .font(.system(size: 20))
                            .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                        Text(tab.title)
                            .font(.caption)
                            .foregroundColor(selectedTab == tab ? .accentColor : .gray)
                    }
                })
                Spacer()
            }
        }
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
        .cornerRadius(16)
        .shadow(radius: 4)
    }
}
