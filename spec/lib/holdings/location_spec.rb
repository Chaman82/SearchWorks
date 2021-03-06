require "spec_helper"

describe Holdings::Location do
  it "should identify location level requests" do
    expect(Holdings::Location.new("SSRC-DATA")).to be_location_level_request
  end
  describe '#name' do
    let(:location_code) { "LOCKED-STK" }
    let(:callnumber) { Holdings::Callnumber.new("barcode -|- GREEN -|- #{location_code} -|- -|- -|-") }
    it "should translate the location code" do
      expect(Holdings::Location.new(location_code).name).to eq "Locked Stacks: ask at circulation desk"
    end
    describe 'location specific translations' do
      it 'should be present for Green' do
        expect(Holdings::Location.new(location_code, [callnumber]).name).to eq "Locked Stacks: ask at Media & Microtext Center"
      end
      it 'should be present for SPEC' do
        expect(Holdings::Location.new("MANUSCRIPT", [Holdings::Callnumber.new("barcode -|- HOOVER -|- MANUSCRIPT -|- -|- -|-")]).name).to eq "Manuscript Collection"
        expect(Holdings::Location.new("MANUSCRIPT", [Holdings::Callnumber.new("barcode -|- SPEC-COLL -|- MANUSCRIPT -|- -|- -|-")]).name).to eq "Manuscript Collection: request at Special Collections service desk"
      end
    end
  end
  describe "#present?" do
    let(:location_no_items_or_mhld) {  Holdings::Location.new("STACKS") }
    let(:location_with_items) { Holdings::Location.new("STACKS", [Holdings::Callnumber.new('barcode -|- GREEN -|- STACKS -|-')]) }
    it "should be true when there are items" do
      expect(location_with_items).to be_present
    end
    it "should be present when there is an mhld" do
      expect(location_no_items_or_mhld).to_not be_present
      location_no_items_or_mhld.mhld = ['something']
      expect(location_no_items_or_mhld).to be_present
    end
    describe "present_on_index?" do
      let(:mhld) { Holdings::MHLD.new('GREEN -|- STACKS -|- something') }
      let(:library_has_mhld) { Holdings::MHLD.new('GREEN -|- STACKS -|- -|- something -|-') }
      it "should not throw an error on items w/o an mhld" do
        expect(location_no_items_or_mhld).to_not be_present_on_index
      end
      it "should return false unless the public note or latest received are present" do
        location_no_items_or_mhld.mhld = [library_has_mhld]
        expect(location_no_items_or_mhld).to_not be_present_on_index
      end
      it "should return true when an item has a present public note or latest received" do
        location_no_items_or_mhld.mhld = [mhld]
        expect(location_no_items_or_mhld).to be_present_on_index
      end
    end
  end
  describe '#location_level_request?' do
    it 'should return true for items that are in request locs' do
      Constants::REQUEST_LOCS.each do |location|
        expect(Holdings::Location.new(location)).to be_location_level_request
      end
    end
  end
  describe 'external locations' do
    let(:external_location) {
      Holdings::Location.new('STACKS', [
        Holdings::Callnumber.new("LL12345 -|- LANE-MED -|- STACKS -|-  -|-  -|- ABC 321 -|-")
      ])
    }
    let(:non_external_location) {
      Holdings::Location.new("STACKS")
    }
    describe '#external_location?' do
      it 'should identify LANE-MED properly' do
        expect(external_location).to be_external_location
      end
      it 'should not identify non LANE-MED items as external locations' do
        expect(non_external_location).to_not be_external_location
      end
    end
    describe '#location_link' do
      it 'should provide a link for external locations' do
        expect(external_location.location_link).to match /http:\/\/lmldb\.stanford\.edu.*&Search_Arg=SOCW\+L12345/
      end
      it 'should strip the first "L" from the barcode' do
        expect(external_location.location_link).to match /L12345/
        expect(external_location.location_link).to_not match /LL12345/
      end
      it 'should just return a link to the lane library catalog if there are no barcoded items' do
        allow(external_location).to receive(:items).and_return([])
        external_location.mhld = [double('mhld', library: "LANE-MED")]
        expect(external_location.location_link).to eq 'http://lmldb.stanford.edu'
      end
      it 'should not provide a link for non-external locations' do
        expect(non_external_location.location_link).to be_nil
      end
    end
  end
  describe "sorting items" do
    let(:callnumbers) { [
      Holdings::Callnumber.new("barcode1 -|- GREEN -|- STACKS -|-  -|-  -|- ABC 321 -|- ABC+321 -|- CBA321 -|- ABC 321 -|- 3 -|- "),
      Holdings::Callnumber.new("barcode2 -|- GREEN -|- STACKS -|-  -|-  -|- ABC 210 -|- ABC+210 -|- CBA210 -|- ABC 210 -|- 2 -|- "),
      Holdings::Callnumber.new("barcode3 -|- GREEN -|- STACKS -|-  -|-  -|- ABC 100 -|- ABC+100 -|- CBA100 -|- ABC 100 -|- 1 -|- ")
    ] }
    let(:location) { Holdings::Location.new("STACKS", callnumbers) }
    it "should sort items by the full shelfkey" do
      expect(location.items.map(&:callnumber)).to eq ["ABC 100", "ABC 210", "ABC 321"]
    end
  end
  describe "#bound_with?" do
    let(:location) { Holdings::Location.new("STACKS") }
    let(:bound_with_location) { Holdings::Location.new("SEE-OTHER") }
    it "should return true for locations that are SEE-OTHER" do
      expect(bound_with_location).to be_bound_with
    end
    it "should return false for locations that are not SEE-OTHER" do
      expect(location).to_not be_bound_with
    end
  end
  describe "#mhld" do
    let(:location) {Holdings::Location.new("STACKS")}
    it "should be an accessible attribute" do
      expect(location.mhld).to_not be_present
      location.mhld = "something"
      expect(location.mhld).to be_present
    end
  end
end
