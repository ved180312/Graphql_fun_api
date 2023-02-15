# frozen_string_literal: true

module Mutations
  class DeleteUser < Mutations::BaseMutation
    argument :id, ID, required: true
    field :user, Types::UserType, null: false
    field :users, [Types::UserType], null: false
    field :errors, [String], null: false

    def resolve(id:)
      user = User.find(id)
      if user.destroy
        { users: User.all,
          errors: [] }
      else
        { errors: user.errors.full_messages }
      end
    end
  end
end

# mutation {
#   deleteUser(input: {id: 8}) {
#     users {
#       id
#       name
#       email
#     }
#     errors
#   }
# }
