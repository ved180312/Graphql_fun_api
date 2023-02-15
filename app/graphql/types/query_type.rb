# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    # /users
    field :users, [Types::UserType], null: false

    def users
      User.all
    end

    # def user
    #   User.where(email: "refugio.hills@beer.com")
    # end

    # /user/:id
    field :user, Types::UserType, null: false do
      argument :id, ID, required: true
    end

    def user(id:)
      User.find(id)
    end

    #-----------------------------post------------------------------

    field :posts, [Types::PostType], null: false

    def posts
      Post.all
    end

    field :post, Types::PostType, null: false do
      argument :id, ID, required: true
    end

    def post(id:)
      Post.find(id)
    end

    # # Add `node(id: ID!) and `nodes(ids: [ID!]!)`
    # include GraphQL::Types::Relay::HasNodeField
    # include GraphQL::Types::Relay::HasNodesField

    # # Add root-level fields here.
    # # They will be entry points for queries on your schema.

    # # TODO: remove me
    # field :test_field, String, null: false,
    #   description: "An example field added by the generator"
    # def test_field
    #   "Hello World!"
    # end
  end
end

# query {
#   users {
#     name
#     email
#     postsCount
#   }
# }

# query {
#   user(id: 2) {
#     name
#     email
#     posts {
#       title
#     }
#   }
# }

# query {
#   posts {
#     title
#     text
#     user_id
#   }
# }
