require 'rails_helper'
require 'selenium-webdriver'

describe 'Product', type: :feature, js: true do
  let(:manager) { FactoryGirl.create(:user, :manager) }

  let(:title) { Faker::Lorem.characters(70) }

  let(:overflow_content) do
    Faker::Lorem.characters(300)
  end

  let(:price) { Random.new.rand(1..12) * 1000 }

  before(:each) do
    sign_in manager
    visit new_product_path
  end

  it 'correctly product' do
    fill_in 'Введіть заголовок',
            with: title
    fill_in 'Введіть ціну', with: price
    click_button 'Створити товар'
    expect(page).to have_content 'Товар успішно створений'
  end

  it 'missing title' do
    fill_in 'Введіть ціну', with: price
    click_button 'Створити товар'
    expect(page).to have_content 'Заповніть поле заголовок'
  end

  it 'overflow title' do
    fill_in 'Введіть заголовок',
            with: overflow_content
    fill_in 'Введіть ціну', with: price
    click_button 'Створити товар'
    expect(page).to have_content 'Заголовок може містити максимум 70 символів'
  end

  it 'missing price' do
    fill_in 'Введіть заголовок',
            with: title
    click_button 'Створити товар'
    expect(page).to have_content 'Введіть коректну ціну'
  end

  it 'incorrect price' do
    fill_in 'Введіть заголовок',
            with: title
    fill_in 'Введіть ціну', with: -1
    click_button 'Створити товар'
    expect(page).to have_content 'Введіть коректну ціну'
  end

  it 'update product price' do
    fill_in 'Введіть заголовок',
            with: title
    fill_in 'Введіть ціну', with: price
    click_button 'Створити товар'

    fill_in 'Введіть ціну',
            with: 5000
    click_button 'Оновити товар'        
    expect(page).to have_content 'Товар успішно оновлено'
  end

  it 'destroy product' do
    fill_in 'Введіть заголовок',
            with: title
    fill_in 'Введіть ціну', with: price
    click_button 'Створити товар'

    click_link 'Переглянути товар'
    click_link 'Видалити'
    sleep 1
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'Товар знищено'
  end  

  context 'when log out' do

    before(:each) do 
      FactoryGirl.create(:role, :guest_role)
      sign_out :user 
    end

    it 'create product and log out' do
      fill_in 'Введіть заголовок',
              with: title
      fill_in 'Введіть ціну', with: price
      click_button 'Створити товар'
      expect(page).to have_content 'Недостатньо прав для здійснення даної дії'
    end
  end
end
