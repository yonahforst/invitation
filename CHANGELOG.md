# Invitation Changelog

## [0.2] - October 17, 2016

Contribution from [augustocbx](https://github.com/augustocbx) adding pt-BR locale file and fixing an init bug.

[0.2]: https://github.com/tomichj/invitation/compare/0.1.1...0.2



## [0.1.1] - April 21, 2016

External APIs and usage remains the same, internal changes only:
* invites controller now users a Form object, form accepts :email or :emails, builds one invite per email address.

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

