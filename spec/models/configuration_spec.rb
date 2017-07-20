require 'spec_helper'
require 'invitation/configuration'

describe Invitation::Configuration do
  describe '#user_model' do
    context 'set to class' do
      it 'has the default user model' do
        @conf = Invitation::Configuration.new
        allow(@conf).to receive(:warn)

        @conf.user_model = User
        expect(@conf.user_model).to eq(User)
        expect(@conf).to have_received(:warn)
      end
    end

    context 'no user class specified' do
      before(:each) do
        @conf = Invitation::Configuration.new
      end

      it 'has the default user model' do
        expect(@conf.user_model).to eq(User)
        expect(@conf.user_model_class_name).to eq('User')
      end
    end

    context 'a namespaced model name' do
      module Gug
        # Faux profile model class
        class Profile
          extend ActiveModel::Naming
        end
      end

      before(:each) do
        @conf = Invitation::Configuration.new
        @conf.user_model = 'Gug::Profile'
      end

      it 'has a user model class name' do
        expect(@conf.user_model_class_name).to eq('Gug::Profile')
      end

      it 'has a user model instance variable name' do
        expect(@conf.user_model_instance_var).to eq('@profile')
      end
    end

    context 'a deeper model name' do
      # Another faux user profile.
      class UserProfile; extend ActiveModel::Naming end

      it 'has a user model instance variable name' do
        @conf = Invitation::Configuration.new
        @conf.user_model = 'UserProfile'
        expect(@conf.user_model_instance_var).to eq('@user_profile')
      end
    end
  end
end
