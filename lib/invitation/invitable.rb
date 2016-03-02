module Invitation
  module Invitable
    def self.included(base)
      base.extend(ClassMethods)
    end


    module ClassMethods
      def invitable(options = {})
        # to: :account
        puts "GUG: invitable #{self.inspect}"
      end
    end
  end
end