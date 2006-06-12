require File.dirname(__FILE__) + '/../test_helper'

class DocumentTest < Test::Unit::TestCase
  fixtures :documents
  
  def test_title
  	document = documents(:oscar)
  	document.title = ""
  	assert !document.save
  end
  
  def test_description
  	document = documents(:oscar)
  	document.description = ""
  	assert !document.save
  end
  
  def test_truth
    assert_kind_of Document, Document.find(:first)
  end
end
