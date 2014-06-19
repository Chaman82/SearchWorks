require "spec_helper"

describe "Location", feature: true, :"data-integration" => true do
  describe "SAL3" do
    it "items should be pageable" do
      visit catalog_path('10385184')

      within('.panel-library-location') do
        within('ul.items') do
          expect(page).to have_css('i.page')
        end
      end
    end
  end
  describe "ARS" do
    it "should be noncirc for non STK item type" do
      visit catalog_path('10160087')

      within('.panel-library-location') do
        within('ul.items') do
          expect(page).to have_css('i.noncirc', count: 3)
        end
      end
    end
    it "should not be noncirc for non STK item type" do
      visit catalog_path('10458422')

      within('.panel-library-location') do
        within('ul.items') do
          expect(page).to_not have_css('i.noncirc')
        end
      end
    end
  end
  describe "standard item" do
    it "should default w/ an unknown item status" do
      visit catalog_path('10424524')

      within('.panel-library-location') do
        within('ul.items') do
          expect(page).to have_css('i.unknown')
        end
      end
    end
  end
end