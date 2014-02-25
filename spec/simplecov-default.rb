require 'simplecov'

if ENV['SIMPLECOV_RCOV_OUTPUT']
  require 'simplecov-rcov'

  class SimpleCov::Formatter::MergedFormatter
    def format(result)
      SimpleCov::Formatter::HTMLFormatter.new.format(result)
      SimpleCov::Formatter::RcovFormatter.new.format(result)
    end
  end
  SimpleCov.formatter = SimpleCov::Formatter::MergedFormatter
end

SimpleCov.start 'rails' do
  add_group "Presenters", "app/presenters" if File.exists?("app/presenters")
end
