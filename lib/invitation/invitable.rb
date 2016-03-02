module Invitation
  module Invitable


    module ClassMethods

      # Make a model such as User able to send invitations.
      #
      # TODO: check for field :email, or allow arbitrary email field to be set
      #
      def invitable(options = {})
        configuration = { to: options[:to] }

        puts "invitable configuration: #{configuration.inspect}"
      end

    end



    module InstanceMethods

    end


  end
end

