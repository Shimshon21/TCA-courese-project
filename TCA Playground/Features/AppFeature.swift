//
//  AppFeature.swift
//  TCA Playground
//
//  Created by Shimshon on 14/03/2024.
//
import ComposableArchitecture
import SwiftUI

@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
          CounterFeature()
        }
        
        Scope(state: \.tab2, action: \.tab2) {
          CounterFeature()
        }
        
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}

struct AppView: View {
    let store1: StoreOf<CounterFeature>
    let store2: StoreOf<CounterFeature>
    
    var body: some View {
        TabView {
            CounterView(store: store1)
                .tabItem {
                    Text("Counter 1")
                }
            
            CounterView(store: store2)
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}
