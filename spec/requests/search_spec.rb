require 'rails_helper'
require 'selenium-webdriver'
 
describe 'Search', type: :feature, js: true do 
  let(:client) { FactoryGirl.create(:user) }

  before(:each) do 
    FactoryGirl.create(:product, title: 'Simple name test')
    FactoryGirl.create(:product, title: 'Create test product')
    FactoryGirl.create(:product, title: 'Test name')

    sign_in client
    visit root_path
    find_by_id('search').click
    sleep 0.5
  end  

  it "check search field with 'test' word"  do 
    fill_in 'search', with: 'test'

    within("#search_action") do
      expect(page).to have_content 'Simple name test'
      expect(page).to have_content 'Create test product'
      expect(page).to have_content 'Test name'
    end  
  end  

  it "check search field with 'name' word"  do 
    fill_in 'search', with: 'name'

    within("#search_action") do
      expect(page).to have_content 'Simple name test'
      expect(page).to have_no_content 'Create test product'
      expect(page).to have_content 'Test name'
    end  
  end  

  it "check search field with 'product' word"  do 
    fill_in 'search', with: 'product'

    within("#search_action") do
      expect(page).to have_no_content 'Simple name test'
      expect(page).to have_content 'Create test product'
      expect(page).to have_no_content 'Test name'
    end  
  end  

  it "check search field with 'new' word"  do 
    fill_in 'search', with: 'new'

    within("#search_action") do
      expect(page).to have_no_content 'Simple name test'
      expect(page).to have_no_content 'Create test product'
      expect(page).to have_no_content 'Test name'
    end  
  end  

  it "check search"  do 
    fill_in 'search', with: 'test'
    click_button 'Пошук'
    
    expect(page).to have_content 'Simple name test'
    expect(page).to have_content 'Create test product'
    expect(page).to have_content 'Test name'
  end  
end  