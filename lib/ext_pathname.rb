class Pathname
  def include?(other)
    absolute? == other.absolute? and other.to_s.start_with?(to_s)
  end

  def absolute_path_from(root)
    unless absolute?
      Pathname.new(root) + self
    else
      self
    end
  end

  def absolute_path_from!(root)
    absolute_path = absolute_path_from(root)
    raise "#{absolute_path} should be into #{root}" unless root.include? absolute_path
    absolute_path
  end

end
