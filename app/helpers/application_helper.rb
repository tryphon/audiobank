# -*- coding: utf-8 -*-
# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include UserVoiceHelper

	def format_time(duration)
		duration.strftime("%H:%M:%S")
	end
	
	def error_messages_for(object_name, options = {})
		options = options.symbolize_keys
		object = instance_variable_get("@#{object_name}")
		if object && !object.errors.empty?
			content_tag("div",
				content_tag(options[:header_tag] || "h2", "#{pluralize(object.errors.count, "erreur a été trouvé", "erreurs ont été trouvées")}") +
					content_tag("ul", object.errors.collect { |name, message| content_tag("li", link_to(message, "##{object_name}_#{name}")) }),
				"id" => options[:id] || "errors", "class" => options[:class] || "errors"
			)
		else
			""
		end
	end
end
