require 'rails_helper'
require 'selenium-webdriver'

describe 'dashboard', type: :feature, js: true do
  it 'input in admin panel as admin' do
    sign_in FactoryGirl.create(:user, :admin)
    visit admin_root_path  

    expect(page).to have_no_content 'Недостатньо прав для здійснення даної дії'
  end  

  it 'input in admin panel as manager' do
    sign_in FactoryGirl.create(:user, :manager)
    visit admin_root_path  

    expect(page).to have_content 'Недостатньо прав для здійснення даної дії'
  end 

  it 'input in admin panel as client' do
    sign_in FactoryGirl.create(:user)
    visit admin_root_path  

    expect(page).to have_content 'Недостатньо прав для здійснення даної дії'
  end 
end  