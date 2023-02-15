# frozen_string_literal: true

module Mutations
  class CreatePost < Mutations::BaseMutation
    argument :title, String, required: true
    argument :body, String, required: true
    argument :user_id, Integer, required: true

    field :post, Types::PostType, null: false
    field :errors, [String], null: false

    def resolve(title:, body:, user_id:)
      post = Post.new(title: title, body: body, user_id: user_id)
      if post.save
        {
          post: post,
          errors: []
        }
      else
        {
          post: nil,
          errors: post.errors.full_messages
        }
      end
    end
  end
end

#   mutation {
#     createPost(input: {
#       title: "Hospital",
#       body: "Hospital",
#        userId: 1
#     }) {
#       post {
#            id,
#         title,
#         body,
#         userId
#       }
#       errors
#     }
#    }
