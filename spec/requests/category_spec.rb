require 'rails_helper'
require 'selenium-webdriver'

describe 'Category', 
  type: :feature, js: true do

  before(:each) { FactoryGirl.create(:role, :guest_role) }  

  it 'show categories' do
    FactoryGirl.create_list(:category, 3, :sub)
    visit root_path

    parent_cat = Category.parent_categories.first
    find("#listener_#{parent_cat.id}").click
    
    # click_link parent_cat.name
    visit category_path(parent_cat)
  end  
end  