namespace :trade do

  desc 'Trade markets'
  task :markets => :environment do

    def has_been_sold(wallet, buy_order, sell_order)
      TransactionService::Close.new.fire!(buy_order, sell_order)
      WalletService::Destroy.new.fire!(wallet, buy_order, sell_order)
    end

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
        wallet = wallets.last
        market_to_sell = wallet.currency.market
        transaction = market_to_sell.transactionns.joins(:account).
                                     where(accounts: {id: 1}).all.last
        sell_order = transaction.sells.last
        buy_order = transaction.buys.last

        if OrderService::Sold.new.fire!(sell_order, market_to_sell.name)
          sell_order = transaction.sells.last
          has_been_sold(wallet, buy_order, sell_order)

        elsif MarketService::ShouldBeSold.new.fire!(markets, market_to_sell.name, buy_order)

          if OrderService::Sell.new.fire!(market_to_sell.name, wallet, buy_order, sell_order)
            has_been_sold(wallet, buy_order, sell_order)
          end
        end
      else

      #------- Buy ---------
        sky_rocket_market = MarketService::DetectSkyRocket.new.fire!(markets, 1, percentile_volume)

        if sky_rocket_market.present?
          #ME HE QUEDADO AQUI
          bought = OrderService::Buy.new.fire!(market_record)

          if bought[:success]
            OrderService::Sell.new.fire!(bought[:order], bought[:wallet], market_record, false)
          end
        end
      end
    end
  end
end
