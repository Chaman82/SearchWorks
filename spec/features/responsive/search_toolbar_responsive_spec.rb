require "spec_helper"

describe "Responsive search bar", js: true, feature: true do
  before do
    visit root_path
    first("#q").set ''
    click_button 'search'
  end
  describe " - desktop view (> 980px)" do
    it "should display correct tools" do
      within "#search-navbar" do
        expect(page).to have_css(".search-form", visible: true)
        expect(page).to have_css("#searchbar-navbar-collapse li", count: 3, visible: true)
      end
    end
  end
  describe " - tablet view (768px - 980px) - " do
    it "should display correct tools" do
      within "#search-navbar" do
        page.driver.resize("800", "800")
        expect(page).to have_css(".search-form", visible: true)
        expect(page).to have_css("#searchbar-navbar-collapse li", count: 3, visible: true)
      end
    end
  end
  describe " - mobile landscape view (480px - 767px) - " do
    it "should display correct tools" do
      page.driver.resize("700", "700")
      within "#search-navbar" do
        expect(page).to have_css(".search-form", visible: true)
        expect(page).to_not have_css("#searchbar-navbar-collapse li", count: 3, visible: true)
        find("button.navbar-toggle").click
        within "#searchbar-navbar-collapse" do
          expect(page).to have_css("li a", text: "ADVANCED", visible: true)
          expect(page).to have_css("li a", text: "BROWSE", visible: true)
          expect(page).to have_css("li a", text: /SELECTIONS/, visible: true)
        end
      end
    end
  end
end
