namespace :test do
  desc "Executes ruby coverage"
  task(:coverage) {
    rcov_file = "coverage.data" 
    rm rcov_file if File.exists?(rcov_file) 
    rcov_options = "--rails --exclude /usr/local/lib/site_ruby,/var/lib/gems,config --aggregate #{rcov_file}"
    system "rcov --no-html #{rcov_options} test/unit/*.rb test/functional/*.rb"
    system "rcov #{rcov_options} test/integration/*.rb"
  }
end
