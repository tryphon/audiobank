module DurationHelper

  def format_duration(duration)
    "%d:%02d" % [duration / 60 , duration % 60]
  end

end
