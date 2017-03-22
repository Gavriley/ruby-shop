require 'rails_helper'
require 'sidekiq/testing'
require 'faker'
require 'json'

describe 'pay response' do 
  before(:all) { Sidekiq::Testing.inline! }
  after(:all) { Sidekiq::Testing.disable! }

  let(:admin) { FactoryGirl.create(:user, :admin) }
  let(:order) { FactoryGirl.create(:order_with_line_items) }

  it 'response from Liqpay' do
    json = 
      { 
        order_id: "#{order.id}, #{order.created_at.strftime("%H:%M:%S").to_s}",
        status: 'sandbox'
      }.to_json

    post liqpay_response_orders_url, 
      {
        data: Base64.encode64(json)
      }

    sign_in admin  
    visit admin_orders_path  
    expect(page).to have_content 'Статус: оплачено'  
    expect(page).to have_content 'Оплачено за допомогою: Liqpay'    
  end  

  it 'response from PayPal' do
    post paypal_response_orders_url, 
      { 
        invoice: "#{order.id}, #{order.created_at.strftime("%H:%M:%S").to_s}", 
        payment_status: 'Completed' 
      }

    sign_in admin  
    visit admin_orders_path  
    expect(page).to have_content 'Статус: оплачено'  
    expect(page).to have_content 'Оплачено за допомогою: PayPal'  
  end 

  it 'response from Stripe' do
    token = Stripe::Token.create(
      {
        card: {
          number: '4242424242424242',
          exp_month: 1,
          exp_year: 2020,
          cvc: 104
        }
      }
    )

    post stripe_response_order_url(order.id),
      {
        stripeEmail: order.email,
        stripeToken: token[:id]
      }

    expect(response).to redirect_to(products_path)
    sign_in admin
    follow_redirect!
    expect(response.body).to include('Товари успішно оплачені')

    sign_in admin
    visit admin_orders_path
    expect(page).to have_content 'Статус: оплачено'  
    expect(page).to have_content 'Оплачено за допомогою: Stripe' 
  end  

  context 'response with error' do 
    it 'response from Liqpay' do
      json = 
        { 
          order_id: "#{order.id}, #{order.created_at.strftime("%H:%M:%S").to_s}",
          status: 'failure',
          err_description: 'error in payment'
        }.to_json

      post liqpay_response_orders_url, 
        {
          data: Base64.encode64(json)
        }

      sign_in admin  
      visit admin_orders_path  
      expect(page).to have_content 'Статус: помилка'  
      expect(page).to have_content 'error in payment'    
    end

    it 'response from PayPal' do
      post paypal_response_orders_url, 
        { 
          invoice: "#{order.id}, #{order.created_at.strftime("%H:%M:%S").to_s}", 
          payment_status: 'Failed' 
        }

      sign_in admin  
      visit admin_orders_path  
      expect(page).to have_content 'Статус: помилка'   
    end   

    it 'response from Stripe' do
      post stripe_response_order_url(order.id),
        {
          stripeEmail: order.email,
          stripeToken: nil
        }

      expect(response).to redirect_to(products_path)
      sign_in admin
      follow_redirect!
      expect(response.body).to include('Помилка при оплаті')

      sign_in admin
      visit admin_orders_path  
      expect(page).to have_content 'Статус: помилка'  
    end  
  end  
end  