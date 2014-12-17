# encoding: utf-8

class Podcast < ActiveRecord::Base
	has_and_belongs_to_many :tags
  has_many :documents, through: :tags

	belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  attr_accessible :title, :description

	validates_presence_of :title, :message => "Le titre ne peut être vide"

  def tag_with(list)
  	Tag.transaction do
  		self.tags = Tag.parse(list)
  	end
  end

  def date
  	return Time.now if documents.empty?
  	documents.first.updated_at
  end
end
