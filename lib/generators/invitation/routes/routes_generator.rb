require 'rails/generators/base'

module Invitation
  module Generators
    class RoutesGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def add_invitation_routes
        route(invitation_routes)
      end

      def disable_invitation_internal_routes
        inject_into_file(
          'config/initializers/invitation.rb',
          "  config.routes = false \n",
          after: "Invitation.configure do |config|\n"
        )
      end

      private

      def invitation_routes
        File.read(routes_file_path)
      end

      def routes_file_path
        File.expand_path(find_in_source_paths('routes.rb'))
      end
    end
  end
end
