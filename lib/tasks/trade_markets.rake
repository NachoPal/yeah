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
      wallets = Wallet.all
      main_wallet = Wallet.main_wallet

      #------- Sell --------
      if wallets.present?
        OrderService::Sold.new.fire!(open_sell[:order], market.name)

        if MarketService::ShouldBeSold.new.fire!(buy_order)
          if OrderService::Sell.new.fire!(buy_order, wallet, market, true)
            has_been_sold(wallet, transaction, market.name, market)
          end
        end

      else
      #------- Buy ---------
        sky_rocket_markets = MarketService::DetectSkyRocket.new.fire!(markets)
      end
    end
  end
end
