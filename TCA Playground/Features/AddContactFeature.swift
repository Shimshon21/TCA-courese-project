//
//  AddContactFeature.swift
//  TCA Playground
//
//  Created by Shimshon on 10/03/2024.
//

import ComposableArchitecture

@Reducer
struct AddContactFeature {
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancelButtonTapped
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        // Delegate action which in charge to notifiy the parent about a change
        // in the child feature and notifiy the parent when it is finished
        enum Delegate: Equatable {
            //case cancel
            case saveContact(Contact)
        }
    }
    
    // Close the current displayed view used with 'AddContactFeature' 
    @Dependency(\.dismiss) var dismiss
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            // Dissmiss the AddContactView
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }
            
            // Save contact and dissmiss the view
            case .saveButtonTapped:
                return .run { [contact = state.contact] send in
                  await send(.delegate(.saveContact(contact)))
                  await self.dismiss()
                }
            
            // Set name from the textfield
            case let .setName(name):
                state.contact.name = name
                return .none
            
            case .delegate(_):
                return .none
            }
        }
    }
}
