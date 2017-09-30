require 'rufus-scheduler'
require 'rake'

Rails.application.load_tasks

start = Rufus::Scheduler.singleton
start_trade = Rufus::Scheduler.singleton
trade = Rufus::Scheduler.singleton

unless defined?(Rails::Console)

  start.in '1s' do
    CACHE.flush_all
    puts "====================== DESTRUYO ========================="
    Orderr.destroy_all
    Wallet.destroy_all
    Transactionn.destroy_all

    Rake::Task['destroy:markets'].execute
    Rake::Task['populate:markets'].execute

    #TODO: Select proper account
    Rake::Task['populate:wallets'].invoke(1)
  end

  start_trade.in '60s' do
    trade.every "#{PERIOD_SEG}s" do
      Rake::Task['trade:markets'].reenable
      Rake::Task['trade:markets'].invoke
    end
  end
end


