module MarketService
  class ShouldBeSold

    def fire!(markets, market_name, buy_order)
      #market_info = Bittrex.client.get("public/getmarketsummary?market=#{market_name}").first
      market_info = markets.select { |market| market['MarketName'] == market_name }

      buy_price = buy_order.limit_price
      current_price = market_info['Bid']
      growth = (((current_price * 100) / buy_price) - 100).round(2)

      growth <= -5
    end
  end
end