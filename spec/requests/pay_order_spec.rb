require 'rails_helper'
require 'selenium-webdriver'
require 'sidekiq/testing'

describe 'PayOrder', type: :feature, js: true do
  let(:client) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create_list(:product, 3)
    sign_in client
    visit products_path
    
    buttons = find_all('.button-cart').map.to_a
    buttons.shift.click
    expect(page).to have_no_content ' 0 шт. - 0.00 грн.'
    buttons.each { |button| button.click }
  end

  it 'create order' do
    visit carts_path
    page.find_by_id('push_order').click
    fill_in 'Введіть адресу', with: 'Коновальця'
    click_button 'Оформити заказ'

    Sidekiq::Testing.inline! do
      expect(page).to have_content '0 шт. - 0.00 грн.'
      expect(page).to have_content 'Заказ №'
    end  
  end

  it 'missing form data' do
    visit carts_path
    page.find_by_id('push_order').click
    click_button 'Оформити заказ'
    expect(page).to have_content 'Заповніть поле адреса'
  end

  context 'if delete line items from cart' do
    before(:each) do
      visit carts_path
      sleep 0.2
      Cart.last.line_items.delete_all
    end

    it 'fill form' do
      page.find_by_id('push_order').click
      fill_in 'Введіть адресу', with: 'Коновальця'
      click_button 'Оформити заказ'
      expect(page).to have_content ' 0 шт. - 0.00 грн.'
      expect(page).to have_content 'Помилка при формуванні заказу'
    end
  end

  # context 'pay with' do
  #   it 'PayPal' do
  #     visit carts_path
  #     page.find_by_id('push_order').click
  #     fill_in 'Введіть адресу', with: 'Коновальця'
  #     click_button 'Оформити заказ'

  #     Sidekiq::Testing.inline! do
  #       expect(page).to have_content '0 шт. - 0.00 грн.'
  #       expect(page).to have_content 'Заказ №'
  #     end  

  #     find_by_id('paypal').click

  #     click_button 'Pay with my PayPal account'
  #     expect(page).to have_content 'PayPal password'
  #     fill_in "login_email", with: "gavrileypetroinsilico@gmail.com"
  #     fill_in "login_password", with: "testpaypal"
  #     click_button "Log In"
  #     sleep 5
  #     find_by_id('continue_abovefold').click
  #     sleep 5
  #     page.driver.browser.navigate.refresh
  #     expect(page).to have_content 'You just made a payment of'
  #     within('#sliderWrapper') do
  #       within('#hdrContainer') do
  #         expect(page).to have_content 'Thanks for your order'
  #       end
  #     end
  #   end  
  # end  
end
