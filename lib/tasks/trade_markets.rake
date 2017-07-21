namespace :trade do

  desc 'Trade markets'
  task :markets => :environment do

    #============= CACHE POPULATION ====================
    result = MarketService::Monitorize.new.fire!

    markets = result[:markets]
    percentile_volume = result[:percentile_volume]
    start_to_trade = result[:cache_population_finished]

    #============= TRADE ===============================
    if start_to_trade
      sky_rocket_markets = MarketService::DetectSkyRocket.new.fire!(markets)

    end

  end
end
