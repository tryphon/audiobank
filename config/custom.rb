# -*- coding: utf-8 -*-
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.delivery_method = :sendmail

require 'core_ext'

WillPaginate::ViewHelpers.pagination_options[:previous_label] = 'Précédente'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Suivante'
