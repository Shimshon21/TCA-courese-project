//
//  CounterFeature.swift
//  TCA Playground
//
//  Created by Shimshon on 06/02/2024.
//

import Foundation
import SwiftUI
import ComposableArchitecture


@Reducer // In charge of update the current state
struct CounterFeature {
    @ObservableState // Update changes in the view
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    // Action used to change the state
    enum Action {
        case decrementButtonTapped
        case factResponse(String)
        case factButtonTapped
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    enum CancelID { case timer }
    
    // Built in dependency for timer usage
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    // Implementations of the actions
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { [count = state.count] send in
                    try await send(.factResponse(self.numberFact.fetch(count)))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                  return .run { send in
                      for await _ in self.clock.timer(interval: .seconds(1)) {
                          await send(.timerTick)
                      }
                  }
                  .cancellable(id: CancelID.timer)
                } else {
                  return .cancel(id: CancelID.timer)
                }
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
            }
        }
    }
}

struct CounterView: View {
    let store: StoreOf<CounterFeature>
    
    var body: some View {
        VStack {
            Text("\(store.count)")
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            HStack {
                Button("-") {
                    store.send(.decrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
                
                Button("+") {
                    store.send(.incrementButtonTapped)
                }
                .font(.largeTitle)
                .padding()
                .background(Color.black.opacity(0.1))
                .cornerRadius(10)
            }
            
            Button(store.isTimerRunning ? "Stop timer" : "Start timer") {
              store.send(.toggleTimerButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            Button("Fact") {
                store.send(.factButtonTapped)
            }
            .font(.largeTitle)
            .padding()
            .background(Color.black.opacity(0.1))
            .cornerRadius(10)
            
            if store.isLoading {
              ProgressView()
            } else if let fact = store.fact {
              Text(fact)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
            }
        }
    }
}

#Preview {
  CounterView(
    store: Store(initialState: CounterFeature.State()) {
      CounterFeature()
    }
  )
}
