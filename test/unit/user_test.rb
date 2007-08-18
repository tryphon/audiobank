require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :users

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
		tags = user.documents.collect{ |d| d.tags }
  end
  
end
