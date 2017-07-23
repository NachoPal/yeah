module MarketService
  class DetectSkyRocket

    def fire!(markets, time_ago, percentile_volume)

      markets.each do |market|
        begin
          array_prices = CACHE.get(market)

          steps = time_ago * 60 / PERIOD_SEG

          array_prices.last(steps).delete(nil)

          growth = (array_prices.last * 100 / array_prices.first) - 100

          Rails.logger.info "Market: #{market} -- Growth: #{growth}" if growth >= 10

          if growth > 5 && market['BaseVolume'] >= percentile_volume
            return market['MarketName']
          end

        rescue  => e
          Rails.logger.info "Error: #{e}"
          Rails.logger.info "GET - > Market: #{market} -- value: #{array_prices}\n\n"
          return nil
        end
      end
    end
  end
end