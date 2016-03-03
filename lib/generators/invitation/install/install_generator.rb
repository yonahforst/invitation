require 'rails/generators/base'
require 'rails/generators/active_record'

module Invitation
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('../templates', __FILE__)

      # args: --model, --org


      def copy_migration_files
        copy_migration 'create_invitations.rb'
      end

      private

      def copy_migration migration_name
        migration_template "db/migrate/#{migration_name}", "db/migrate/#{migration_name}"
      end

    end
  end
end
