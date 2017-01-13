require 'rails_helper'
require 'selenium-webdriver'

describe 'PayOrder', type: :feature, js: true do
  let(:client) { FactoryGirl.create(:user) }

  before(:each) do
    FactoryGirl.create_list(:product, 3)
    sign_in client
    visit products_path
    find_all('.button-cart').each do |button|
      button.click
      sleep 0.2
    end  
  end

  it 'create order' do
    visit carts_path
    page.find_by_id('push_order').click
    fill_in 'Введіть адресу', with: 'Коновальця'
    click_button 'Оформити заказ'
    expect(page).to have_content '0шт. - 0.00 грн.'
    expect(page).to have_content 'Заказ №'
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
      expect(page).to have_content '0шт. - 0.00 грн.'
      expect(page).to have_content 'Помилка при формуванні заказу'
    end
  end
end
