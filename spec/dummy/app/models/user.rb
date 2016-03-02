class User < ActiveRecord::Base
  invitable to: :company
end
