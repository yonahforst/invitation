require 'rails/generators/base'
require 'rails/generators/active_record'
require 'generators/invitation/helpers'

module Invitation
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      include Invitation::Generators::Helpers

      source_root File.expand_path('../templates', __FILE__)

      class_option :model, optional: true, type: :string, banner: 'model',
                   desc: "Specify the model class name if you will use anything other than 'User'"

      class_option :invitable, optional: true, type: :array, banner: 'invitable',
                   desc: "Specify the model class name if you will use anything other than 'User'"

      def verify
        if options[:model] && !File.exists?(model_path)
          puts "Exiting: the model class you specified, #{options[:model]}, is not found."
          exit 1
        end
      end

      def verify_invitable
        return unless options[:invitable]
        options[:invitable].each do |invitable|
          unless File.exists?(invitable_file_path invitable)
            puts "Exiting: the model class you specified to make invitable, #{invitable}, is not found."
            exit 1
          end
        end
      end

      def inject_into_user_model
        inject_into_class model_path, model_class_name, "  include Invitation::User\n\n"
      end

      def inject_into_invitables
        options[:invitable].each do |invitable|
          path = invitable_file_path(invitable)
          class_name = invitable.classify
          inject_into_class path, class_name, "  include Invitation::Invitable\n\n"
        end
      end

      def copy_migration_files
        copy_migration 'create_invites.rb'
      end

      def create_initializer
        copy_file 'invitation.rb', 'config/initializers/invitation.rb'
        if options[:model]
          inject_into_file(
              'config/initializers/invitation.rb',
              "  config.user_model = '#{options[:model]}' \n",
              after: "Invitation.configure do |config|\n",
          )
        end
      end

      private

      def copy_migration migration_name
        migration_template "db/migrate/#{migration_name}", "db/migrate/#{migration_name}"
      end

      # for generating a timestamp when using `create_migration`
      def self.next_migration_number(dir)
        ActiveRecord::Generators::Base.next_migration_number(dir)
      end

    end
  end
end
