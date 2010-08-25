# Include hook code here
require 'user_voice'
require 'user_voice_helper'

if defined? ActionView::Base
  ActionView::Base.send :include, UserVoiceHelper
end
