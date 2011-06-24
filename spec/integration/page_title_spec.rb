require 'spec_helper'

describe "Page titles" do
  it "uses the specified title when provided by the view" do
    visit '/breadcrumbs_test'
    page.find("title").should have_content "Breadcrumbs"
  end

  it "uses 'Untitled Page' when no title was provided" do
    visit '/control_sets_test'
    page.find("title").should have_content "Untitled Page"
  end
end
