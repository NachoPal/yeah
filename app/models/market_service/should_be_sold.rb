module MarketService
  class ShouldBeSold

    def fire!(markets, market_name, buy_order)
      #market_info = Bittrex.client.get("public/getmarketsummary?market=#{market_name}").first
      market_info = markets.select { |market| market['MarketName'] == market_name }.first

      Rails.logger.info market_info
      buy_price = buy_order.limit_price
      current_price = market_info['Ask']
      growth = (((current_price * 100) / buy_price) - 100).round(2)

      bought_time_ago = (Time.zone.now - buy_order.created_at) / 60

      Rails.logger.info "Growth: #{growth}"
      Rails.logger.info "Time ago: #{bought_time_ago}"

      growth <= -THRESHOLD_OF_LOST || bought_time_ago > GET_RID_OFF_AFTER_MIN
    end
  end
end