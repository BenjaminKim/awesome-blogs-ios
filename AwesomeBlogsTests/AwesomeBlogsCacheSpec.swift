//
//  AwesomeBlogsCacheSpec.swift
//  AwesomeBlogs
//
//  Created by wade.hawk on 2017. 8. 27..
//  Copyright © 2017년 wade.hawk. All rights reserved.
//

import Foundation
import RxSwift
import Quick
import Nimble
import Swinject
import Moya
import ObjectMapper
import RealmSwift

@testable import AwesomeBlogs

class AwesomeBlogsCacheSpec: QuickSpec {
    override func spec() {
        var disposeBag: DisposeBag!
        //describe("어썸 블로그 feed cache 테스트") {
        context("awesome blog feed cache test") {
            beforeEach {
                disposeBag = DisposeBag()
                Service.shared.deleteFeedCache()
            }
            //describe("mock 데이터 사용하도록 의존성 주입") {
            describe("DI: used mock data") {
                beforeEach {
                    Service.shared.mockRegister()
                }
                it("empty -> api call -> cache database") {
                    var counts: [Int] = []
                    let cache = AwesomeBlogsLocalSource.getFeeds(group: .dev).map{ $0.entries.count }
                    let api = Api.getFeeds(group: .dev).map{ $0.count }.asObservable()
                    Observable.concat([cache,api,cache]).subscribe(onNext: { count in
                        counts.append(count)
                    }).disposed(by: disposeBag)
                    expect(counts).toEventually(equal([103,103]), timeout: 20)
                }
            }
        }
    }
}
