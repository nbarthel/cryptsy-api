require "spec_helper"
require "cryptsy/api"

describe Cryptsy::API::Client do
  before do
    @client = Cryptsy::API::Client.new
  end

  it "should return general market data" do
    result = @client.marketdata
    result.wont_be_nil && result["success"].must_equal(1)
  end

  it "should return single market data" do
    result = @client.marketdata(94)
    result.wont_be_nil && result["success"].must_equal(1)
  end

  it "should return orderbook data" do
    result = @client.orderdata
    result.wont_be_nil && result["success"].must_equal(1)
  end

  it "should return single market orderbook data" do
    result = @client.orderdata(94)
    result.wont_be_nil && result["success"].must_equal(1)
  end

end
