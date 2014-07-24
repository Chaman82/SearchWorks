require "spec_helper"

feature "Brief View" do
  scenario "Search results", js: true do
    visit catalog_index_path f: {format: ["Book"]}
    page.find('#view-type-dropdown button.dropdown-toggle').click
    page.find('#view-type-dropdown .dropdown-menu li a.view-type-brief').click

    expect(page).to have_css("i.fa.fa-align-justify")
    expect(page).to have_css(".brief-document h3.index_title", text: "An object")
    expect(page).to have_css(".brief-document button.btn-preview", text: "Preview")
    expect(page).to have_css("form.bookmark_toggle label.toggle_bookmark", text: "Select")

    page.find("button.btn.docid-1").click
    expect(page).to have_css("li", text: "1990")
  end
end
