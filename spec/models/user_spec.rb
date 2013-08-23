# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User, "validation" do

  fixtures :users

  before do
    @user = users(:first)
    @user.should be_valid
  end

  it "should accept username 'radio-esperanzah'" do
    @user.username = 'radio-esperanzah'
    @user.should be_valid
  end

  it "should accept username with 20 characters" do
    @user.username = 'x' * 20
    @user.should be_valid
  end

  it "should not accept username longer than 20" do
    @user.username = 'x' * 21
    @user.should have(1).error_on(:username)
  end

  it "should accept username with 3 characters" do
    @user.username = 'x' * 3
    @user.should be_valid
  end

  it "should not accept username smaller than 3" do
    @user.username = 'x' * 2
    @user.should have(1).error_on(:username)
  end

  it "should make an error 'Le nom d'utilisateur est limité à x caractères' when username too long" do
    @user.username = 'x' * 40
    @user.should_not be_valid
    @user.should have(1).errors_on(:username)
  end

  it "should make an error 'Le nom d'utilisateur doit faire au moins x caractères' when username too short" do
    @user.username = 'x' * 2
    @user.should_not be_valid
    @user.should have(1).errors_on(:username)
  end

  it "should make an error 'Le nom d'utilisateur ne peut contenir que des minuscules, des chiffres et '-' (a..z0..9-)' when format is invalid" do
    @user.username = 'x ' * 2
    @user.should_not be_valid
    @user.should have(1).errors_on(:username)
  end

end

describe User do

  let(:user) { Factory :user }

  describe ".authenticate" do

    it "should strip given password" do
      user.update_attribute :password, "dummy"
      User.authenticate(user.username, " dummy ").should == user
    end

  end

  describe "#documents" do

    describe "#download_count" do

      it "should be zero by default" do
        subject.documents.download_count.should be_zero
      end

    end

  end

  describe "#authentication_token" do

    it "should be defined when user is created" do
      Factory(:user).authentication_token.should be_present
    end

  end

end
