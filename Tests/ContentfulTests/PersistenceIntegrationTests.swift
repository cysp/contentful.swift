//
//  PersistenceIntegrationTests.swift
//  Contentful
//
//  Created by JP Wright on 08/01/18.
//  Copyright © 2018 Contentful GmbH. All rights reserved.
//

@testable import Contentful
import Foundation
import XCTest
import Nimble

class PersistenceIntegrationTests: XCTestCase {
    

    func testSerializingLocationWithNSCdoing() {
        do {
            let jsonDecoder = Client.jsonDecoderWithoutLocalizationContext()
            let spaceJSONData = JSONDecodingTests.jsonData("space")
            let space = try! jsonDecoder.decode(Space.self, from: spaceJSONData)
            Client.update(jsonDecoder, withLocalizationContextFrom: space)

            let entryJSONData = JSONDecodingTests.jsonData("entry-with-location")
            let entry = try jsonDecoder.decode(Entry.self, from: entryJSONData)

            let location = entry.fields["center"] as? Contentful.Location
            expect(location).toNot(beNil())

            NSKeyedArchiver.archiveRootObject(location as Any, toFile: "location")
            let deserializedLocation = NSKeyedUnarchiver.unarchiveObject(withFile: "location") as? Contentful.Location
            expect(deserializedLocation?.latitude).to(equal(location?.latitude))
            expect(deserializedLocation?.latitude).to(equal(48.856614))
            expect(deserializedLocation?.longitude).to(equal(2.3522219000000177))

        } catch _ {
            fail("Asset decoding should not throw an error")
        }
    }
}
