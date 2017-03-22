require 'rails_helper'
require 'selenium-webdriver'

describe 'order', type: :feature, js: true do
  before :each do 
    FactoryGirl.create_list(:product, 3)
    sign_in FactoryGirl.create(:user, :admin)

    3.times do
      visit products_path
      buttons = find_all('.button-cart').map.to_a
      buttons.shift.click
      expect(page).to have_no_content ' 0 шт. - 0.00 грн.'
      buttons.each { |button| button.click }
      
      visit carts_path
      page.find_by_id('push_order').click
      fill_in 'Введіть адресу', with: 'Коновальця'
      click_button 'Оформити заказ'
    end 
    
  end  

  it 'show all orders' do
    visit admin_orders_path 
    expect(page).to have_content 'Імя замовника:'
  end  

  it 'destroy all orders' do
    visit admin_orders_path 

    3.times do
      find_all('#delete_link').first.click
      sleep 0.2
      page.driver.browser.switch_to.alert.accept
    end  
    
    expect(page).to have_no_content 'Імя замовника:'
  end  

  it 'show last order' do
    last_id = Order.last.id
    visit admin_order_path last_id
    expect(page).to have_content "Замовлення №#{last_id}" 
  end  
end  