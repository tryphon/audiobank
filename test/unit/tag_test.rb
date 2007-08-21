require File.dirname(__FILE__) + '/../test_helper'

class TagTest < Test::Unit::TestCase
  fixtures :tags
  
  def test_parse
    first = tags(:first)
    another = tags(:another)
    
    tags = [first, another]
    
    assert_equal [first], Tag.parse(first.to_s)
    assert_equal tags, Tag.parse(Tag.format(tags))
    
    assert_equal [first], Tag.parse(first)
    assert_equal tags, Tag.parse(tags)
    assert_equal tags, Tag.parse([ first.to_s, another.to_s ])
  end
  
  def to_s
    first = tags(:first)
    another = tags(:another)
    
    list = Tag.format([first, another])
    assert_equal "first another", list
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
