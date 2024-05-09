//
//  ContactsFeatureTests.swift
//  TCA PlaygroundTests
//
//  Created by Balink on 09/05/2024.
//

import ComposableArchitecture
import XCTest

@testable import ContactsApp

@MainActor
final class ContactsFeatureTests: XCTestCase {
  func testAddFlow() async {
      let store = TestStore(initialState: ContactsFeature.State()) {
        ContactsFeature()
      }
      
      await store.send(.addButtonTapped) {
          $0.destination = .addContact(
            AddContactFeature.State(
              contact: Contact(id: ???, name: "")
            )
          )
      }
  }
}
