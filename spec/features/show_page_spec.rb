require "spec_helper"

feature "Search Results Page" do
  before do
    visit catalog_path 11
  end
  scenario "should have correct page title" do
    expect(page).to have_title("Amet ad & adipisicing ex mollit pariatur minim dolore.")
  end
  scenario "should have the vernacular title" do
    expect(page).to have_css('.vernacular-title', text: 'Currently, to obtain more information from the weakness of the resultant pain.')
  end
  scenario "should have resource type icon" do
    expect(page).to have_css("li span.sul-icon")
  end
end
