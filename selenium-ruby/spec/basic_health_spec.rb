require 'rails_helper'

RSpec.describe "Basic Health Check Tests", type: :system do
  it "should take a screenshot of homepage" do
    visit 'http://httpd:80'
    save_screenshot('/opt/selenium/image.png')
  end
  # go to google.com and test the page title
  it "should go to homepage and test page title" do
    visit 'http://httpd:80'
    expect(page).to have_title('Papyri.info')
  end
end