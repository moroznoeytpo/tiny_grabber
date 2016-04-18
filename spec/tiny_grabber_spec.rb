require 'spec_helper'

describe TinyGrabber do
  it 'has a version number' do
    expect(TinyGrabber::VERSION).not_to be nil
  end

  it 'get page without proxy' do
    responce = TinyGrabber.get 'https://www.google.ru/'
    expect(responce.code).to eq("200")
  end
end
