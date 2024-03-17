//
//  ContactsFeature.swift
//  TCA Playground
//
//  Created by Shimshon on 09/03/2024.
//

import ComposableArchitecture
import Foundation

struct Contact: Equatable, Identifiable {
  let id: UUID
  var name: String
}

@Reducer
struct ContactsFeature {
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
                return .none
                
            case .addContact(.presented(.delegate(.saveContact(let contact)))):
                state.contacts.append(contact)
                return .none
                
            case .addContact:
                return .none
            }
        }
        // Bind to add contact feature in case add contact is non-nil
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
}
