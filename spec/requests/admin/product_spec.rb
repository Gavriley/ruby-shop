require 'rails_helper'
require 'selenium-webdriver'

describe 'Product', type: :feature, js: true do
  before :each do
    sign_in FactoryGirl.create(:user, :admin)
    FactoryGirl.create_list(:product, 3)
    visit admin_products_path
  end  

  it 'show products' do
    Product.all.each do |product|
      expect(page).to have_content product.title
    end  
  end 

  it 'destroy all products' do
    3.times do
      find_all('#delete_link').first.click
      sleep 0.2
      page.driver.browser.switch_to.alert.accept
    end  

    expect(page).to have_no_content 'Переглянути'
  end  

  context 'search products' do
    before(:each) do 
      FactoryGirl.create(:product, title: 'Simple name test')
      FactoryGirl.create(:product, title: 'Create test product')
      FactoryGirl.create(:product, title: 'Test name')
    end  

    it "check search field with 'test' word" do
      fill_in 'Найти продукт', with: 'test'

      expect(page).to have_content 'Simple name test'
      expect(page).to have_content 'Create test product'
      expect(page).to have_content 'Test name'

      Product.first(3).each do |product|
        expect(page).to have_no_content product.title
      end  
    end  

    it "check search field with 'name' word" do
      fill_in 'Найти продукт', with: 'name'

      expect(page).to have_content 'Simple name test'
      expect(page).to have_no_content 'Create test product'
      expect(page).to have_content 'Test name'

      Product.first(3).each do |product|
        expect(page).to have_no_content product.title
      end  
    end  

    it "check search field with 'product' word" do
      fill_in 'Найти продукт', with: 'product'

      expect(page).to have_no_content 'Simple name test'
      expect(page).to have_content 'Create test product'
      expect(page).to have_no_content 'Test name'

      Product.first(3).each do |product|
        expect(page).to have_no_content product.title
      end  
    end  

    it "check search field with 'new' word" do
      fill_in 'Найти продукт', with: 'new'

      Product.all.each do |product|
        expect(page).to have_no_content product.title
      end  
    end  
  end  
end  