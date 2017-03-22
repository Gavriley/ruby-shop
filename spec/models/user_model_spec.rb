require 'rails_helper'

describe User do
  it 'user attributes should be fill' do
    user = User.new

    expect(user).to be_invalid
  end

  it 'search' do
    User.search('new')
  end  
end
