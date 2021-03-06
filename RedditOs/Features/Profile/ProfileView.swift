//
//  ProfileView.swift
//  RedditOs
//
//  Created by Thomas Ricouard on 11/07/2020.
//

import SwiftUI
import Backend

struct ProfileView: View {
    @EnvironmentObject private var oauthClient: OauthClient
    @EnvironmentObject private var currentUser: CurrentUser
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        NavigationView {
            List {
                if let user = currentUser.user {
                    HStack(spacing: 32) {
                        Spacer()
                        makeStatsView(number: user.commentKarma.toRoundedSuffixAsString(),
                                      name: "Comment Karma")
                        makeStatsView(number: user.linkKarma.toRoundedSuffixAsString(),
                                      name: "Link Karma")
                        Spacer()
                    }.padding(.top, 16)
                } else {
                    authView
                }
            }
            .listStyle(PlainListStyle())
            .frame(width: 400)
        }
        .navigationTitle(currentUser.user?.name ?? "Login")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    oauthClient.logout()
                } label: {
                    Text("Logout")
                }

            }
        }
    }
    
    private func makeStatsView(number: String, name: String) -> some View {
        VStack {
            Text(number)
                .font(.title)
                .fontWeight(.bold)
            Text(name)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.gray)
        }
    }
        
    @ViewBuilder
    var authView: some View {
        switch oauthClient.authState {
        case .signedOut:
            Button {
                if let url = oauthClient.startOauthFlow() {
                    openURL(url)
                }
            } label: {
                Text("Sign in")
            }
        case .signinInProgress:
            ProgressView("Auth in progress")
        case .authenthicated:
            Text("Signed in")
        case .unknown:
            Text("Error")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
