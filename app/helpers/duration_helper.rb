module DurationHelper

  def format_duration(duration)
    "#{duration / 60}:#{duration % 60}"
  end

end
