//
//  CategoryListCellSpec.swift
//  Ello
//
//  Created by Colin Gray on 6/16/2016.
//  Copyright (c) 2016 Ello. All rights reserved.
//

@testable import Ello
import Quick
import Nimble
import Nimble_Snapshots


class CategoryListCellSpec: QuickSpec {
    override func spec() {
        describe("CategoryListCell") {
            var subject: CategoryListCell!
            beforeEach {
                subject = CategoryListCell(frame: CGRect(origin: .zero, size: CGSize(width: 320, height: 66)))
                showView(subject)
            }

            it("displays categories") {
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "Art", slug: "art"),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("hides categories that are off screen") {
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "MMMMMMMMM", slug: "mmmmmmmmm1"),
                    (title: "MMMMMMMMM", slug: "mmmmmmmmm2"),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("highlights the selected category") {
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "Art", slug: "art"),
                ]
                subject.selectedCategory = "featured"
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("highlights the selected category, regardless of assignment order") {
                subject.selectedCategory = "featured"
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "Art", slug: "art"),
                ]
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }

            it("highlights the selected category, after assigning duplicates") {
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "Art", slug: "art"),
                ]
                subject.selectedCategory = "featured"
                subject.categories = [
                    (title: "Featured", slug: "featured"),
                    (title: "Art", slug: "art"),
                ]
                subject.selectedCategory = "art"
                subject.layoutIfNeeded()
                expect(subject).to(haveValidSnapshot())
            }
        }
    }
}