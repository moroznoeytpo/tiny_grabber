require 'spec_helper'

describe TinyGrabber do

  it 'has a version number' do
    expect(TinyGrabber::VERSION).not_to be nil
  end

  it 'HTTPS GET' do
    response = TinyGrabber.get 'https://www.google.ru/search?q=привет'
    expect(response.code).to eq("200")
  end

  it 'HTTP POST' do
    response = TinyGrabber.post 'http://ras.arbitr.ru/Ras/Search', {},
      headers: {
          'Accept' => 'application/json',
          'Host' => 'ras.arbitr.ru',
          'X-Requested-With' => 'XMLHttpRequest'
      }
    expect(response.code).to eq("200")
  end
end
