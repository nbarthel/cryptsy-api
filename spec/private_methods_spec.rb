require "spec_helper"
require "cryptsy/api"

describe Cryptsy::API::Client do
  before do
    @client = Cryptsy::API::Client.new("XXX","XXX")
  end

  it "should return getinfo" do
    result = @client.getinfo
    result.wont_be_nil && result["success"].must_equal(1)
  end

end
