require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users, :documents

	def	test_username 
		user = users(:elmo)
		user.username = ""
		assert !user.save
	end
	
	def	test_name
		user = users(:elmo)
		user.name = ""
		assert !user.save
	end 
	
	def	test_email
		user = users(:elmo)
		user.email = "elmo at ruesesame dot fr"
		assert !user.save
	end

	def	test_password 
		user = users(:elmo)
		password = user.password
		user.password = user.username
		assert_equal password, user.password		
	end 

  def test_truth
  	assert_kind_of User, User.find(:first)
  end
  
  def test_documents
		user = users(:elmo)
		assert ! user.documents.empty?
  end
  
  def test_authenticate
		user = users(:elmo)
		
		clear_password = "test"
		user.password = clear_password
		user.save
		
    logged_user = User.authenticate(user.username, clear_password)
    assert_not_nil logged_user

    assert_equal user, logged_user
  end
  
end
