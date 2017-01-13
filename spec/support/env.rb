Capybara.register_driver :chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' =>
    { 'args' => ['--start-maximized'] })
  $driver = Capybara::Selenium::Driver.new(app,
                                           browser: :chrome,
                                           desired_capabilities: caps)
end

Capybara.javascript_driver = :chrome
