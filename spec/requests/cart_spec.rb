require 'rails_helper'
require 'selenium-webdriver'

describe 'Cart', 
  type: :feature, js: true do
  
  let(:client) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create_list(:product, 3)
    sign_in client
    visit products_path
    find_all('.button-cart').each do |button|
      button.click
      sleep 0.2
    end  
    # find_all('.button-cart').each { |link| link.click; sleep 1 }
    # CleanerCartWorker.perform_in(7.days, Cart.last.id)
  end

  # context 'wait few days' do

  #   it 'after 7 days' do
  #     # Timecop.travel(Date.today + 10.days)
  #     Timecop.freeze(Date.today + 30) do 
  #       # puts Time.now
  #       visit carts_path
  #     end  
  #     # puts Time.now
      
  #     # expect(page).to have_content '0шт. - 0.00 грн.'
  #   end
  # end

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

  it 'destroy all items' do 
    visit carts_path

    find_all('.destroy_item').each do |lick|
      lick.click
      sleep 0.2
    end  

    expect(page).to have_content 'Корзина пуста'
  end  

  it 'add some item' do 
    visit carts_path
    click_button 'Знищити корзину'
    visit product_path(Product.last)
    fill_in 'count', with: 10
    click_button 'В кошик'
    
    expect(page).to have_content '10шт.'
  end  
end
