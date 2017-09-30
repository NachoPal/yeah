module MarketService
  class DetectSkyRocket

    def fire!(markets, percentile_volume)

      markets.each do |market|
        begin
          array_prices = CACHE.get(market['MarketName'])

          #steps = SKY_ROCKET_PERIOD_SEG * 60 / PERIOD_SEG
          steps = SKY_ROCKET_PERIOD_SEG / PERIOD_SEG

          array_prices.last(steps).delete(nil)

          growth = (array_prices.last * 100 / array_prices.first) - 100

          Rails.logger.info "\nMarket: #{market['MarketName']} -- Growth: #{growth}" #if growth >= 10
          #Rails.logger.info array_prices

          if growth > SKY_ROCKET_GAIN &&
             market['BaseVolume'] >= percentile_volume && good_trend(array_prices)

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

    def good_trend(array_prices)
      step_value = 60 / PERIOD_SEG
      trend = []

      (0..array_prices.size - 1).step(step_value).each do |i|
        sub_array_prices = array_prices[i..i + step_value - 1]
        growth = (sub_array_prices.last * 100 / sub_array_prices.first) - 100

        (growth > 0)? trend << true : trend << false

        positive = trend.count(true).to_f
        negative = trend.count(false).to_f

        (negative/positive) * 100 < TREND_THRESHOLD
      end
    end
  end
end