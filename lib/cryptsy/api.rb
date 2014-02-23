require "cryptsy/api/version"
require "httparty"
require "uri"
require "openssl"
require "json"

module Cryptsy
  module API
    class PublicMethod
      include HTTParty
      base_uri "http://pubapi.cryptsy.com"

      def execute_method(all_markets, single_market, marketid)
        api_method = marketid.nil? ? all_markets : single_market
        query = {method: api_method}
        query["marketid"] = marketid if marketid

        response = self.class.get("/api.php", query: query)
        JSON.parse(response.body)
      end
    end

    class PrivateMethod
      include HTTParty
      base_uri "https://api.cryptsy.com"

      def initialize(key=nil, secret=nil)
        @key = key
        @secret = secret
      end

      def execute_method(method_name, params)
        post_data = {method: method_name, nonce: nonce}.merge(params)
        post_body = URI.encode_www_form(post_data)

        response = self.class.post("/api",
                           headers: { "User-Agent" => "Mozilla/4.0 (compatible; Cryptsy API ruby client)",
                                    "Sign" => signed_message(post_body),
                                    "Key" => @key,
                           },
                           body: post_data)
        JSON.parse(response.body)
      end

      def auth_changed?(key, secret)
        return @key == key && @secret == secret
      end

     private

       def nonce
         Time.now.to_i
       end

       def signed_message(msg)
         OpenSSL::HMAC.hexdigest('sha512', @secret, msg)
       end

    end

    class Client
      def initialize(key=nil, secret=nil)
        @key = key
        @secret = secret
        @private_caller = nil
      end

      # Public APIs

      # We don't bother to support deprecated v1 api
      def marketdata(marketid=nil)
        call_public_api("marketdatav2", "singlemarketdata", marketid)
      end

      def orderdata(marketid=nil)
        call_public_api("orderdata", "singleorderdata", marketid)
      end

      # Private APIs

      def getinfo
        call_private_api("getinfo", {})
      end

      def getmarkets
        call_private_api("getmarkets", {})
      end

      def getwalletstatus
        call_private_api("getwalletstatus", {})
      end

      def mytransactions
        call_private_api("mytransactions", {})
      end

      def markettrades(marketid)
        call_private_api("markettrades", {marketid: marketid})
      end

      def marketorders(marketid)
        call_private_api("marketorders", {marketid: marketid})
      end

      def depth(marketid)
        call_private_api("depth", {marketid: marketid})
      end

      def mytrades(marketid, limit=nil)
        params = {marketid: marketid}
        params.merge({limit: limit}) if limit
        call_private_api("mytrades", params)
      end

      def allmytrades(startdate=nil,enddate=nil)
        params = {}

	if !startdate.nil?
          if startdate.is_a?(Date)
            startdate = startdate.strftime("%Y-%m-%d")
          end
          params[:startdate] = startdate
        end

	if !enddate.nil?
          if enddate.is_a?(Date)
            enddate = enddate.strftime("%Y-%m-%d")
          end
          params[:enddate] = enddate
        end

        call_private_api("allmytrades", params)
      end

      def myorders(marketid)
        call_private_api("myorders", {marketid: marketid})
      end

      def allmyorders
        call_private_api("allmyorders", {})
      end

      def createorder(marketid, ordertype, quantity, price)
        call_private_api("createorder",
                         {marketid: marketid,
                          ordertype: ordertype,
                          quantity: quantity,
                          price: price})
      end

      def cancelorder(orderid)
        call_private_api("cancelorder", {orderid: orderid})
      end

      def cancelmarketorders(marketid)
        call_private_api("cancelmarketorders", {marketid: marketid})
      end

      def cancelallorders
        call_private_api("cancelallorders", {})
      end

      def calculatefees(ordertype, quantity, price)
        call_private_api("calculatefees",
                         {ordertype: ordertype,
                          quantity: quantity,
                          price: price})
      end

      def generatenewaddress(currency)
        # if integer - it is currency id
        if currency.is_a? Integer or !!(currency =~ /^[-+]?[0-9]+$/)  then
          call_private_api("generatenewaddress", {currencyid: currency})
        else
          call_private_api("generatenewaddress", {currencycode: currency})
        end
      end

      def mytransfers
        call_private_api("mytransfers", {})
      end

      def makewithdrawal(address, amount)
        call_private_api("makewithdrawal", {address: address, amount: amount})
      end

      private
        def call_public_api(all_markets, single_market, marketid=nil)
          Cryptsy::API::PublicMethod.new.execute_method(all_markets, single_market, marketid)
        end

        def call_private_api(method_name, params={})
          if @private_caller.nil? || @private_caller.auth_changed?(@key, @secret)
            @private_caller = Cryptsy::API::PrivateMethod.new(@key,@secret)
          end
          @private_caller.execute_method(method_name, params)
        end
    end
  end
end
