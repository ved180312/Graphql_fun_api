# frozen_string_literal: true

module Mutations
  class UpdatePost < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :title, String, required: true
    argument :body, String, required: true
    argument :user_id, ID, required: false

    field :post, Types::PostType, null: false
    field :errors, [String], null: false

    def resolve(title:, body:, id:, user_id: nil)
      post = Post.find(id)

      if post.update(title: title, body: body, user_id: user_id)
        {
          post: post,
          errors: []
        }
      else
        {
          errors: post.errors.full_messages
        }
      end
    end
  end
end

# mutation {                         ----------Query
#     updatePost(input: {
#       id: 1
#       title: "ved",
#       body: "ved tiwari"
#     }) {
#       post {
#         id,
#         title,
#         body,
#         user_id
#       }
#       errors
#     }
#    }
