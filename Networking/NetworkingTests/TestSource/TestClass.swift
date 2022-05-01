//
//  TestClass.swift
//  NetworkingTests
//
//  Created by Petimezas, Chris, Vodafone on 1/5/22.
//

import Foundation
import Combine
@testable import Networking

typealias PostCompletion = (Result<PostResponseElement, ProviderError>) -> Void
typealias PostsCompletion = (Result<PostsResponse, ProviderError>) -> Void
typealias CommentsCompletion = (Result<CommentsResponse, ProviderError>) -> Void
typealias VoidCompletion = (Result<Response, ProviderError>) -> Void

class TestClass {
    let provider = Networking()
    var postsSubscriber: AnyPublisher<PostsResponse, ProviderError>?
    var postSubscriber: AnyPublisher<PostResponseElement, ProviderError>?
    var commentSubscriber: AnyPublisher<CommentsResponse, ProviderError>?
    var noBodySubscriber: AnyPublisher<Response, ProviderError>?
    var subscriber = CommentSubscriber()
    var anyCancellable: AnyCancellable?
    var isDebugEnabled: Bool = true {
        didSet {
            provider.preference.isDebuggingEnabled = isDebugEnabled
        }
    }
}

// MARK: - Publisher Test Functions
extension TestClass {
    func fetchPosts() {
        postsSubscriber = provider.request(
            with: TestTarget.fetchAllPosts,
            scheduler: RunLoop.main,
            class: PostsResponse.self
        )
    }

    func fetchPostById(_ id: Int = 1) {
        postSubscriber = provider.request(
            with: TestTarget.fetchPostById(id: id),
            scheduler: RunLoop.main,
            class: PostResponseElement.self
        )
    }

    func fetchPostsByUserId(userId: Int = 1) {
        postsSubscriber = provider.request(
            with: TestTarget.fetchPostsByUserId(userId: userId),
            scheduler: RunLoop.main,
            class: PostsResponse.self
        )
    }

    func createPost(title: String = "Foo", body: String = "Bar", userId: Int = 1) {
        postSubscriber = provider.request(
            with: TestTarget.createPost(
                title: title,
                body: body,
                userId: userId
            ),
            scheduler: RunLoop.main,
            class: PostResponseElement.self
        )
    }

    func updatePostWithPut(postId: Int = 1, userId: Int = 1, title: String = "Foo", body: String = "Bar") {
        postSubscriber = provider.request(
            with: TestTarget.updatePostById(
                postId: postId,
                title: title,
                body: body,
                userId: userId
            ),
            scheduler: RunLoop.main,
            class: PostResponseElement.self)
    }

    func updatePostWithPatch(postId: Int = 1, title: String = "") {
        postSubscriber = provider.request(
            with: TestTarget.updatePostPartly(
                postId: postId,
                title: title
            ),
            scheduler: RunLoop.main,
            class: PostResponseElement.self)
    }

    func deletePost(with id: Int = 1) {
        noBodySubscriber = provider.request(
            with: TestTarget.deletePostById(postId: id),
            scheduler: RunLoop.main
        )
    }

    func fetchCommentsWithPostId(_ id: Int = 1) {
        commentSubscriber = provider.request(
            with: TestTarget.fetchCommentsByPostId(postId: id),
            scheduler: RunLoop.main,
            class: CommentsResponse.self
        )
    }

    func fetchCommentsWithSubscriber(_ id: Int = 1) {
        provider.request(with: TestTarget.fetchCommentsByPostId(postId: id), class: CommentsResponse.self, scheduler: RunLoop.main, subscriber: self.subscriber)
    }
}

// MARK: - Completion Test Functions
extension TestClass {
    func fetchPosts(result: @escaping PostsCompletion) {
        provider.request(with: TestTarget.fetchAllPosts, class: PostsResponse.self, result: result)
    }

    func fetchPostById(with id: Int = 1, result: @escaping PostCompletion) {
        provider.request(
            with: TestTarget.fetchPostById(id: id),
            class: PostResponseElement.self,
            result: result)
    }

    func fetchPostsByUserId(_ userId: Int = 1, result: @escaping PostsCompletion) {
        provider.request(
            with: TestTarget.fetchPostsByUserId(userId: userId),
            class: PostsResponse.self,
            result: result)
    }

    func createPost(title: String = "Foo", body: String = "Bar", userId: Int = 1, result: @escaping PostCompletion) {
        provider.request(
            with: TestTarget.createPost(
                title: title,
                body: body,
                userId: userId),
            class: PostResponseElement.self,
            result: result)
    }

    func updatePostWithPut(postId: Int = 1, userId: Int = 1, title: String = "Foo", body: String = "Bar", result: @escaping PostCompletion) {
        provider.request(
            with: TestTarget.updatePostById(
                postId: postId,
                title: title,
                body: body,
                userId: userId),
            class: PostResponseElement.self,
            result: result)
    }

    func updatePostWithPatch(postId: Int = 1, title: String = "", result: @escaping PostCompletion) {
        provider.request(
            with: TestTarget.updatePostPartly(
                postId: postId,
                title: title),
            class: PostResponseElement.self,
            result: result)
    }

    func deletePost(with id: Int = 1, result: @escaping VoidCompletion ) {
        provider.request(
            with: TestTarget.deletePostById(postId: id),
            result: result)
    }

    func fetchCommentsWithPostId(_ id: Int = 1, result: @escaping CommentsCompletion) {
        provider.request(
            with: TestTarget.fetchCommentsByPostId(postId: id),
            class: CommentsResponse.self,
            result: result)
    }
}
