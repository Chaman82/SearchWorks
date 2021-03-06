require "spec_helper"

describe Holdings::Library do
  include Marc856Fixtures
  it "should translate the library code" do
    expect(Holdings::Library.new("GREEN").name).to eq "Green Library"
  end
  describe "#locations" do
    let(:callnumbers) { [
      Holdings::Callnumber.new("barcode -|- library -|- home-loc -|- "),
      Holdings::Callnumber.new("barcode -|- library -|- home-loc2 -|- "),
      Holdings::Callnumber.new("barcode -|- library -|- home-loc -|- ")
    ] }
    let(:sort_callnumbers) { [
      Holdings::Callnumber.new("barcode -|- library -|- TINY -|- "),
      Holdings::Callnumber.new("barcode -|- library -|- STACKS -|- "),
      Holdings::Callnumber.new("barcode -|- library -|- CURRENTPER -|- ")
    ] }
    let(:locations) { Holdings::Library.new("GREEN", nil, callnumbers).locations }
    let(:sort_locations) { Holdings::Library.new("GREEN", nil, sort_callnumbers).locations }
    it "should return an array of Holdings::Locations" do
      expect(locations).to be_a Array
      locations.each do |location|
        expect(location).to be_a Holdings::Location
      end
    end
    it "should group by home location" do
      expect(callnumbers.length).to eq 3
      expect(locations.length).to eq 2
    end
    it "should sort by location code when there is no translation" do
      expect(locations.map(&:code)).to eq ["home-loc", "home-loc2"]
    end
    it "should sort locations alpha by name" do
      expect(sort_locations.map(&:name)).to eq ["Current Periodicals", "Miniature", "Stacks"]
      expect(sort_locations.map(&:code)).to eq ["CURRENTPER", "TINY", "STACKS"]
    end
  end
  describe "#present?" do
    let(:callnumbers) { [
      Holdings::Callnumber.new(""),
      Holdings::Callnumber.new(""),
      Holdings::Callnumber.new("")
    ] }
    let(:library) { Holdings::Library.new("GREEN", nil, callnumbers) }
    it "should be false when libraries have no item display fields" do
      expect(library).to_not be_present
    end
  end
  describe "#location_level_request?" do
    it "should return true for all libraries that should be requestable at the location level" do
      Constants::REQUEST_LIBS.each do |library|
        expect(Holdings::Library.new(library)).to be_location_level_request
      end
    end
    describe 'HOPKINS' do
      let(:item_display) { "12345 -|- HOPKINS -|- STACKS -|- " }
      let(:callnumbers) {[Holdings::Callnumber.new(item_display)]}
      let(:online_doc) { SolrDocument.new(marcxml: fulltext_856) }
      let(:online_lib) { Holdings::Library.new("HOPKINS", online_doc, callnumbers) }
      let(:single_item_doc) { SolrDocument.new(item_display: [item_display]) }
      let(:not_online_lib) { Holdings::Library.new("HOPKINS", single_item_doc, callnumbers) }
      let(:multi_holdings_doc) { SolrDocument.new(item_display: [item_display, "54321 -|- GREEN -|- STACKS -|- "]) }
      let(:multiple_holding_lib) { Holdings::Library.new("HOPKINS", multi_holdings_doc, callnumbers) }
      it 'should return true for materials that are not available online' do
        expect(not_online_lib).to be_location_level_request
      end
      it 'should return false for materials that exist in other libraries' do
        expect(multiple_holding_lib).to_not be_location_level_request
      end
      it 'should return false for materials that are available online' do
        expect(online_lib).to_not be_location_level_request
      end
    end
  end
  describe '#library_instructions' do
    it 'should return instructions for libraries which have them' do
      Constants::LIBRARY_INSTRUCTIONS.each_key do |library|
        expect(Holdings::Library.new(library).library_instructions).to have_key(:heading)
        expect(Holdings::Library.new(library).library_instructions).to have_key(:text)
      end
    end
  end
  describe "zombie" do
    let(:zombie) { Holdings::Library.new("ZOMBIE") }
    it "should be #zombie?" do
      expect(zombie).to be_zombie
    end
    it "should not be a holding library" do
      expect(zombie).to_not be_holding_library
    end
  end
  describe "#mhld" do
    let(:library) {Holdings::Library.new("GREEN")}
    it "should be an accessible attribute" do
      expect(library.mhld).to_not be_present
      library.mhld = "something"
      expect(library.mhld).to be_present
    end
  end
end
