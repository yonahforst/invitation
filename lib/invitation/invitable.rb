module Invitation
  module Invitable


    module ClassMethods

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

