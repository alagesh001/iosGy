//
//  MainScreenView.swift
//  LoginScreenApp
//
//  Created by Creative Frenzy on 15/05/25.
//

import SwiftUI

struct MainScreenView: View {
    let gym: Gym
    
    var body: some View {
        VStack(spacing: 30) {
            NavigationLink("My Clients", destination: MyClientsView())
            NavigationLink("Trainer / Dietician", destination: MyClientsView())
            NavigationLink("Search Filter", destination: MyClientsView())
            NavigationLink("Broadcast Message", destination: MyClientsView())
            NavigationLink("Add Products", destination: MyClientsView())
            NavigationLink("Virtual Coach", destination: MyClientsView())
            
            Spacer()
        }
        .navigationTitle(gym.gymName)
        .padding()
    }
}
