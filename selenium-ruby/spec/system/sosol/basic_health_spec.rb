require 'rails_helper'

RSpec.describe "Basic Health Check Tests", type: :system do
  it "should take a screenshot of homepage" do
    visit '/editor/signin'
    save_screenshot('/opt/selenium/sosol_home.png')
  end
  # go to google.com and test the page title
  it "should go to homepage and test page title" do
    visit '/editor/signin'
    expect(page).to have_title('Papyri.info')
  end
end