# frozen_string_literal: true

module GraphQL
  class Schema
    class Resolver
      # Adds `field(...)` helper to resolvers so that they can
      # generate payload types.
      #
      # Or, an already-defined one can be attached with `payload_type(...)`.
      module HasPayloadType
        # Call this method to get the derived return type of the mutation,
        # or use it as a configuration method to assign a return type
        # instead of generating one.
        # @param new_payload_type [Class, nil] If a type definition class is provided, it will be used as the return type of the mutation field
        # @return [Class] The object type which this mutation returns.
        def payload_type(new_payload_type = nil)
          if new_payload_type
            @payload_type = new_payload_type
          end
          @payload_type ||= generate_payload_type
        end

        def type(new_type = nil, null: nil)
          if new_type
            payload_type(new_type)
            if !null.nil?
              self.null(null)
            end
          else
            super()
          end
        end

        alias :type_expr :payload_type

        def field_class(new_class = nil)
          if new_class
            @field_class = new_class
          elsif defined?(@field_class) && @field_class
            @field_class
          else
            find_inherited_value(:field_class, GraphQL::Schema::Field)
          end
        end

        # An object class to use for deriving return types
        # @param new_class [Class, nil] Defaults to {GraphQL::Schema::Object}
        # @return [Class]
        def object_class(new_class = nil)
          if new_class
            if defined?(@payload_type)
              raise "Can't configure `object_class(...)` after the payload type has already been initialized. Move this configuration higher up the class definition."
            end
            @object_class = new_class
          else
            @object_class || find_inherited_value(:object_class, GraphQL::Schema::Object)
          end
        end

        NO_INTERFACES = [].freeze

        def field(*args, **kwargs, &block)
          pt = payload_type # make sure it's initialized with any inherited fields
          field_defn = super

          # Remove any inherited fields to avoid false conflicts at runtime
          prev_fields = pt.own_fields[field_defn.graphql_name]
          case prev_fields
          when GraphQL::Schema::Field
            if prev_fields.owner != self
              pt.own_fields.delete(field_defn.graphql_name)
            end
          when Array
            prev_fields.reject! { |f| f.owner != self }
            if prev_fields.empty?
              pt.own_fields.delete(field_defn.graphql_name)
            end
          end

          pt.add_field(field_defn, method_conflict_warning: false)
          field_defn
        end

        private

        # Build a subclass of {.object_class} based on `self`.
        # This value will be cached as `{.payload_type}`.
        # Override this hook to customize return type generation.
        def generate_payload_type
          resolver_name = graphql_name
          resolver_fields = all_field_definitions
          Class.new(object_class) do
            graphql_name("#{resolver_name}Payload")
            description("Autogenerated return type of #{resolver_name}.")
            resolver_fields.each do |f|
              # Reattach the already-defined field here
              # (The field's `.owner` will still point to the mutation, not the object type, I think)
              # Don't re-warn about a method conflict. Since this type is generated, it should be fixed in the resolver instead.
              add_field(f, method_conflict_warning: false)
            end
          end
        end
      end
    end
  end
end
