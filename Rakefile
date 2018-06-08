#!/usr/bin/env rake
# begin
#   require 'bundler/setup'
# rescue LoadError
#   puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
# end

require 'bundler/setup'
require 'bundler/gem_tasks'
require 'appraisal'

# Bundler::GemHelper.install_tasks

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'
require 'rspec/core/rake_task'

namespace :dummy do
  require_relative "spec/dummy/config/application"
  Dummy::Application.load_tasks
end

RSpec::Core::RakeTask.new(:spec)

desc 'Run all specs in spec directory (excluding plugin specs)'
task default: :spec
