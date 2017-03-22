require 'rails_helper'

describe 'ApplicationController', type: :request do
  it 'not found page' do
    get '/not/found/request'
    expect(response).to have_http_status(404)
  end  

  it 'not exists product' do
    get edit_product_path(9999999)
    expect(response).to have_http_status(404)
  end 

  it 'admin panel unexists page' do
    get '/admin/not/found/request'
    expect(response).to have_http_status(404)
  end 

  it 'admin panel not exists user' do
    sign_in FactoryGirl.create(:user, :admin)
    get edit_admin_user_path(9999999)
    expect(response).to have_http_status(404)
  end 

  it 'set uk locale' do
    sign_in FactoryGirl.create(:user)
    get '/uk'
    expect(response.body).to include('Магазин')
    expect(response.body).to include('Головна')
    expect(response.body).to include('Кабінет')
    expect(response.body).to include('Вихід')
    expect(response.body).to include('Ви увійшли як')
  end  

  it 'set en locale' do
    sign_in FactoryGirl.create(:user)
    get '/en'
    expect(response.body).to include('Shop')
    expect(response.body).to include('Home')
    expect(response.body).to include('Office')
    expect(response.body).to include('Log out')
    expect(response.body).to include('You are logged in as')
  end  

  it 'set underfined location' do
    sign_in FactoryGirl.create(:user)
    get '/ru'
    expect(response).to have_http_status(404)
  end  
end  