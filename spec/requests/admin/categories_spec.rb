require 'rails_helper'
require 'selenium-webdriver'

describe 'categories', type: :feature, js: true do
  before :each do
    sign_in FactoryGirl.create(:user, :admin)

    visit admin_categories_path

    fill_in 'Введіть назву', with: 'category'
    click_button 'Створити категорію'
  end  

  it 'add parent category' do
    expect(page).to have_content 'category (Кількість продуктів: 0)'
    expect(page).to have_content 'Категорія успішно добавлена'
  end  

  it 'add sub category' do

    fill_in 'Введіть назву', with: 'sub category'
    within '#categories_list' do
      find("option[value='#{Category.last.id}']").click
    end  
    click_button 'Створити категорію'

    expect(page).to have_content 'sub category (Кількість продуктів: 0)'
    expect(page).to have_content 'Категорія успішно добавлена'
  end  

  it 'edit category' do
    click_link 'Редагувати'
    
    within '#modal' do
      fill_in 'Введіть назву', with: 'new category'
      click_button 'Оновити категорію'
    end

    expect(page).to have_content 'new category (Кількість продуктів: 0)'
    expect(page).to have_content 'Категорія успішно оновлена'
  end  

  it 'delete category' do
    click_link 'Видалити'
    sleep 0.2
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'Категорія успішно видалена'
    expect(page).to have_no_content 'category (Кількість продуктів: 0)'
  end  
end  