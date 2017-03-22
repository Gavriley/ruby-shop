require 'rails_helper'
require 'selenium-webdriver'

describe 'Cart', 
  type: :feature, js: true do
  
  let(:client) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create_list(:product, 3)
    sign_in client
    visit products_path
    
    buttons = find_all('.button-cart').map.to_a
    buttons.shift.click
    
    expect(page).to have_no_content '0 шт. - 0.00 грн.'
    buttons.each { |button| button.click }
  end

  context 'clean cart' do
    it 'clean with sidekiq' do
      Sidekiq::Testing.inline! do
        expect(page).to have_content '0 шт. - 0.00 грн.'
      end  
    end

    it 'clean card with count down items' do
      visit carts_path

      Cart.last.line_items.each do
        find('a', text: '◀', match: :prefer_exact).click
        sleep 0.2
      end
        
      expect(page).to have_content 'Корзина пуста'
    end  

    it 'destroy all items' do 
      visit carts_path

      find_all('.destroy_item').each do |lick|
        lick.click
        sleep 0.2
      end  

      expect(page).to have_content 'Корзина пуста'
    end  
  end  

  it 'manage cart' do 
    find_all('.button-cart').each do |button|
      button.click
      sleep 0.2
    end  

    visit carts_path
    find_all('.arrow').each do |lick|
      lick.click
      sleep 0.2
    end  
  end  

  it 'destroy cart' do 
    visit carts_path
    click_button 'Знищити корзину'
    expect(page).to have_content 'Корзина пуста'
  end 

  it 'add some item' do 
    visit carts_path
    click_button 'Знищити корзину'
    visit product_path(Product.last)
    fill_in 'count', with: 10
    click_button 'В кошик'
    
    expect(page).to have_content '10 шт.'
  end
end
