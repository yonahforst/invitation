# Invitation

A Rails gem to issue scoped invitations. 

Allow users to invite others to join an invitable organization or resource. Plenty of gems
can issue a 'system-wide' invitation, but few offer 'scoped' invitations, giving an invited user access to
a particular invitable organization or resource.

Invitations are issued via email. You can invite users new to the system, or invite existing users by giving
them access to a new resource.


## Overview

To issue an invitation:

* a user can invite someone to join an invitable by providing an email address to invite
* if the user already exists, that user is added to the invitable, and a notification email is sent
* if the user does not exist, the app sends an email with a link to sign up. When the new user signs up,
they are added to the invitable organization or resource.
* the invite grants the invited user access to ONLY the invitable organization they were invited to


## Prerequisites

* An authentication system with a User model and current_user helper. I use https://rubygems.org/gems/authenticate.
* You user model must include an :email attribute
* An second model for an 'organization' that groups users in a many-to-many association.

A example user-to-organization system you might be familiar with: Basecamp's concepts of accounts and users.


## Install

To get started, add Invitation to your `Gemfile` and run `bundle install` to install it:

```ruby
gem 'invitation'
```

Then run the authenticate install generator:

```sh
rails generate invitation:install
```

The install generator does the following:

* Insert `include Invitation::User` into your `User` model.
* Add an initializer at `config/intializers/authenticate.rb`.
* Create a migration for the Invite class.

You'll need to run the migration that Invitation just generated.

```sh
rake db:migrate
```

### Invitables

You'll need to manually configure resources, called invitables, to invite users to. Each invitable needs `include Invitation::Invitable`
and the class method `invitable_named_by` set with the name of a method or attribute to call for the invitable's name.

```ruby
class Company < ActiveRecord::Base
  include Invitation::Invitable
  invitable_named_by :name
end
```

### User Registration

Your user registration 


## Configure

Override any of these defaults in your application `config/initializers/authenticate.rb`.

```ruby
Invitation.configure do |config|
  config.user_model = '::User'
  config.user_registration_url = ->(params) { Rails.application.routes.url_helpers.sign_up_url(params) } 
  config.mailer_sender = 'reply@example.com'
  config.url_after_invite = '/'
end
```

Configuration parameters are described in detail here: [Configuration](lib/authenticate/configuration.rb)


## Use




## Extend or Override




## Thanks

This gem was inspired by and draws heavily from:
* https://gist.github.com/jlegosama/9026919

With additional inspiration from:

* https://github.com/scambra/devise_invitable


## Future changes

* accepted flag, so we can scope invites by accepted vs not yet accepted
* expiration date - invites expire, scope expired by not expired
* move all view text to locale
* issue many invitations at once?
* generators for views, controllers, configuration
* dynamic user name lookup? requires JS, CSS


## License

This project rocks and uses MIT-LICENSE.

