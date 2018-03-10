# Invitation Changelog

## [0.4.5] - September 30, 2017

### Bugfix:
- migration versioned for Rails >= 5

[0.4.5]: https://github.com/tomichj/invitation/compare/0.4.4...0.4.5


## [0.4.4] - September 30, 2017
- recipient association optional for Rails >= 5

[0.4.4]: https://github.com/tomichj/invitation/compare/0.4.3...0.4.4


## [0.4.3] - July 1, 2017

### API change
- configuration.user_model now accepts the user class (with a warning), or the user class name (a String)
 
[0.4.3]: https://github.com/tomichj/invitation/compare/0.4.2...0.4.3



## [0.4.2] - July 1, 2017

### API change
- accept a string for configuration.user_model and constantize it
 
[0.4.2]: https://github.com/tomichj/invitation/compare/0.4.1...0.4.2



## [0.4.1] - April 26, 2017

### Bugfix:
- added case_insensitive_email to template used by install generator
 
[0.4.1]: https://github.com/tomichj/invitation/compare/0.4...0.4.1



## [0.4] - April 26, 2017

### Feature:
- added case_sensitive_email configuration option.

[0.4]: https://github.com/tomichj/invitation/compare/0.3...0.4



## [0.3] - March 26, 2017

### Feature:
- Added support for Rails 5.1

[0.3]: https://github.com/tomichj/invitation/compare/0.2...0.3



## [0.2] - October 17, 2016

### Feature:
- adding pt-BR locale file and fixing an init bug.

[0.2]: https://github.com/tomichj/invitation/compare/0.1.1...0.2



## [0.1.1] - April 21, 2016

### Internal changes:
- invites controller now users a Form object, form accepts :email or :emails, builds one invite per email address.

[0.1.1]: https://github.com/tomichj/invitation/compare/0.1.0...0.1.1


## [0.1.0] - April 18, 2016

* `invites#create` supports :email or emails:[] in request, via html or json.
* `invites#create` error message reports emails it failed to invite
* `invites#create` invite_issued or invite_error messages now 'count' sensitive, e.g. "Invitation issued" vs "Invitations issued"
* removed after_invite_url from config, after invite user is redirected to invitable's show action
* added config.routes, set to true by default.
* fixed invitation view generator packaging
* significantly more tests

[0.1.0]: https://github.com/tomichj/invitation/compare/0.0.2...0.1.0


## [0.0.2] - April 11, 2016

* invites#create supports html or json. Redirects to invitable with html, returns invite (minus token) as json.
* gemspec dependencies cleaned up
* documentation updated

[0.0.2]: https://github.com/tomichj/invitation/compare/0.0.1...0.0.2


## 0.0.1 - April 9, 2016

Initial release.

