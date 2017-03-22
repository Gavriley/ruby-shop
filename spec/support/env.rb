Capybara.register_driver :chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' =>
    { 'args' => ['--start-maximized'] })
  $driver = Capybara::Selenium::Driver.new(app,
                                           browser: :chrome,
                                           desired_capabilities: caps)
end

# Capybara.server_port = 9515
# Capybara.server_host = 'http://3abad41d.ngrok.io'

Capybara.javascript_driver = :chrome
