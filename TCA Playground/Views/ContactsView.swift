//
//  ContactsView.swift
//  TCA Playground
//
//  Created by Shimshon on 10/03/2024.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    @Bindable var store: StoreOf<ContactsFeature>
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(store.contacts) { contact in
          Text(contact.name)
        }
      }
      .navigationTitle("Contacts")
      .toolbar {
        ToolbarItem {
          Button {
            store.send(.addButtonTapped)
          } label: {
            Image(systemName: "plus")
          }
        }
      }
      .sheet(
        item: $store.scope(state: \.addContact, 
                           action: \.addContact)
      ) { addContactStore in
        NavigationStack {
          AddContactView(store: addContactStore)
        }
      }
    }
  }
}

#Preview {
    ContactsView(store: Store(initialState: ContactsFeature.State(contacts: [Contact(id: UUID(), name: "Blob 1"),
                                                                             Contact(id: UUID(), name: "Blob 2"),
                                                                             Contact(id: UUID(), name: "Blob 3")]), reducer: {
        ContactsFeature()
    }))
}
