//
//  
//  HomeView.swift
//  CryptoTracker
//
//  Created by Mahin Ibrahim on 04/10/2021.
//
//

import SwiftUI

struct HomeView: View {
    
    enum Field {
        case minRate
        case maxRate
    }
    
    @StateObject var viewModel:  HomeViewModel
    
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Crypto Tracker")
        }
    }
}

extension HomeView {
    var contentView: some View {
        Form {
            exchangeRateSectionView
            minMaxAcceptableRateSectionView
        }
    }
}

extension HomeView {
    var exchangeRateSectionView: some View {
        Section {
            HStack {
                Spacer()
                Text("$ 55")
                    .font(.largeTitle)
                Spacer()
            }
        }
    }
}

extension HomeView {
    var minMaxAcceptableRateSectionView: some View {
        Section(footer: updateButtonView) {
            HStack {
                Text("Min rate")
                Spacer()
                TextField("Enter the min acceptable rate", text: $viewModel.minimalAcceptableRate)
                    .focused($focusedField, equals: .minRate)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Text("Max rate")
                Spacer()
                TextField("Enter the max acceptable rate", text: $viewModel.maximalAcceptableRate)
                    .focused($focusedField, equals: .maxRate)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }
        }
    }
    
    var updateButtonView: some View {
        HStack {
            Spacer()
            Button("UPDATE") {
                focusedField = nil
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: 300, maxHeight: 60)
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
