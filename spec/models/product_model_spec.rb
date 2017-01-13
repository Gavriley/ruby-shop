require 'rails_helper'

describe Product do
  it 'product attributes should be fill' do
    product = Product.new

    expect(product).to be_invalid
    expect(product.errors[:title]).to be_any
    expect(product.errors[:description]).to be_empty
    expect(product.errors[:thumbnail]).to be_empty
    expect(product.errors[:price]).to be_any
    expect(product.errors[:user]).to be_any
    expect(product.errors[:published]).to be_empty
  end

  it 'product price should be grater or equal to 0.01' do
    product = FactoryGirl.create(:product)

    product.price = -1

    expect(product).to be_invalid

    product.price = 0

    expect(product).to be_invalid

    product.price = 1

    expect(product).to be_valid
  end
end
