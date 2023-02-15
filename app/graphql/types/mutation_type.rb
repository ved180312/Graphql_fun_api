# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser
    field :delete_user, mutation: Mutations::DeleteUser
    field :update_user, mutation: Mutations::UpdateUser

    field :create_post, mutation: Mutations::CreatePost
    field :delete_post, mutation: Mutations::DeletePost
    field :update_post, mutation: Mutations::UpdatePost
  end
end
