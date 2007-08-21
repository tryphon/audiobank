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
  
  def test_match_tags
    document = documents(:oscar)
    document.tag_with("tag1 tag2")
    
    for tag in document.tags
      assert document.match_tags?(tag)
    end
    assert document.match_tags?(document.tags)
    
    unknown_tag = Tag.find_or_create_by_name("unknown")
    assert ! document.match_tags?(unknown_tag)
    assert ! document.match_tags?(document.tags + [ unknown_tag ])
  end
  
  def test_truth
    assert_kind_of Document, Document.find(:first)
  end
end
