require "spec_helper"

describe FeedbackFormHelper do
  describe "show_feedback_form?" do
    let(:form_controller) { FeedbackFormsController.new }
    before do
      form_controller.extend(FeedbackFormHelper)
      form_controller.stub(:controller).and_return(form_controller)
    end
    it "should return false when being viewed under the FeedbackFormsController" do
      expect(form_controller.show_feedback_form?).to be_false
    end
    it "should return true when not under the FeedbackFormsController" do
      expect(helper.show_feedback_form?).to be_true
    end
  end
  describe 'show_quick_report?' do
    it 'should be false unless it meets certain criteria' do
      expect(helper.show_quick_report?).to be_false
    end
    it 'should return true when coming from a show page' do
      params = { controller: 'catalog', action: 'show' }
      helper.stub(:params).and_return(params)
      expect(helper.show_quick_report?).to be_true
    end
    it 'should return true when the referrer is a show page and current controller is feedback' do
      params = { controller: 'feedback_forms', action: 'new' }
      controller.request.should_receive(:referer).at_least(:once).and_return('http://127.0.0.1:3000/view/12')
      helper.stub(:params).and_return(params)
      expect(helper.show_quick_report?).to be_true
    end
  end
  describe 'refered_from_catalog_show?' do
    it 'should be true if referer is from view show' do
      controller.request.should_receive(:referer).at_least(:once).and_return('http://127.0.0.1:3000/view/12')
      expect(helper.refered_from_catalog_show?).to be_true
    end
    it 'should be true if referer is from catalog show' do
      controller.request.should_receive(:referer).at_least(:once).and_return('http://127.0.0.1:3000/catalog/12')
      expect(helper.refered_from_catalog_show?).to be_true
    end
    it 'should be false if not a show page' do
      controller.request.should_receive(:referer).at_least(:once).and_return('http://127.0.0.1:3000/catalog?f%5Baccess_facet%5D%5B%5D=At+the+Library&f%5Baccess_facet%5D%5B%5D=Online')
      expect(helper.refered_from_catalog_show?).to be_false
    end
    it 'should be false if referer is nil' do
      controller.request.should_receive(:referer).at_least(:once).and_return(nil)
      expect(helper.refered_from_catalog_show?).to be_false
    end
  end
end
