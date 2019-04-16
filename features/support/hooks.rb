Before do
	
	Capybara.reset_sessions!
end

After do |scenario|
Dir.mkdir('prints') unless Dir.exist?('prints')

	sufix = ('error' if scenario.failed?) || 'success'
	name = scenario.name.tr(' ', '_').downcase

	page.save_screenshot("prints/#{sufix}-#{name}.png")
	embed("prints/#{sufix}-#{name}.png", 'image/png', 'Screenshot')
end

at_exit do
    time = Time.now.getutc
    ReportBuilder.configure do |config|
    config.junit_path = 'result'    
    config.json_path = 'report.json'
    config.report_path = 'cucumber_web_report'
    config.report_types = [:html]
    config.report_tabs = %w[Overview Features Scenarios Errors]
    config.report_title = 'Cucumber Report Builder web automation test results'
    config.compress_images = false
    config.additional_info = { 'Project name' => 'Test', 'Platform' => 'Integration', 'Report generated' => time }
    end
    ReportBuilder.build_report
end
