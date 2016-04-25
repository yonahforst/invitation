require 'invitation/engine'
require 'invitation/configuration'
require 'invitation/user'
require 'invitation/invitable'
require 'invitation/user_registration'

# Top level module of invitation gem.
module Invitation
end

# ActiveRecord::Base.send :include, Invitation::Invitable
ActiveRecord::Base.extend Invitation::Invitable
