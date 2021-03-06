require 'spec_helper'

feature "Zero results" do
  before do
    visit root_path
    first("#q").set '9999zzzz2222'
    click_button 'search'
  end
  scenario "search widgets and start over should not be present" do
    expect(page).to_not have_css("a.catalog_startOverLink", text: "Start Over")
    expect(page).to_not have_css("div#search-widgets")
  end
  scenario "should have correct headings and elements present" do
    within "#content" do
      expect(page).to have_css("h3", text: "Modify your search")
      expect(page).to have_css("h3", text: "Check other sources")
    end
    within "#sidebar" do
      expect(page).to have_css("h3", text: "Want help?")
      expect(page).to have_css("h3", text: "On the library website")
      expect(page).to have_css("a", count: 4)
    end
  end
end
