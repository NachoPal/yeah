module MarketService
  class DetectSkyRocket

    def fire!(markets, time_ago, percentile_volume)

      markets.each do |market|
        begin
          array_prices = CACHE.get(market['MarketName'])

          #steps = time_ago * 60 / PERIOD_SEG
          steps = time_ago / PERIOD_SEG

          array_prices.last(steps).delete(nil)

          growth = (array_prices.last * 100 / array_prices.first) - 100

          Rails.logger.info "\nMarket: #{market['MarketName']} -- Growth: #{growth}" #if growth >= 10
          #Rails.logger.info array_prices

          if growth > SKY_ROCKET_GAIN #&& market['BaseVolume'] >= percentile_volume
            single_growth = single_buyer(array_prices)
            Rails.logger.info "#{market['MarketName']} - Single Growth: #{single_growth}"
            unless single_buyer(array_prices)
              return market['MarketName']
            end
          end

        rescue  => e
          Rails.logger.info "Error: #{e}"
          Rails.logger.info "GET - > Market: #{market['MarketName']} -- growth: #{growth} -- percentil: #{percentile_volume}\n\n value: #{array_prices} \n\n"
          return nil
        end
      end
      nil
    end

    private

    def single_buyer(array_prices)
      growth = (array_prices.last * 100 / array_prices.last(2).first) - 100
      growth > SKY_ROCKET_GAIN
    end
  end
end