# frozen_string_literal: true

module Mutations
  class UpdateUser < Mutations::BaseMutation
    argument :id, ID, required: true
    argument :name, String, required: true
    argument :email, String, required: true

    field :user, Types::UserType, null: false
    field :errors, [String], null: false

    def resolve(name:, email:, id:)
      user = User.find(id)

      if user.update(name: name, email: email)
        {
          user: user,
          errors: []
        }
      else
        {
          errors: user.errors.full_messages
        }
      end
    end
  end
end

# mutation {                         ----------Query
#     updateUser(input: {
#       id: 1
#       name: "ved",
#       email: "andy@web-crunch.com"
#     }) {
#       user {
#         id,
#         name,
#         email
#       }
#       errors
#     }
#    }
