module TransactionService
  class Close

    def fire!(transaction, buy_order, sell_order)
      result = calculate_statistics(buy_order, sell_order)

      transaction.update(benefit: result[:benefit], percentage: result[:percentage])
    end

    def calculate_statistics(buy_order, sell_order)
     buy_price = buy_order.limit_price
     sell_price = sell_order.limit_price
     quantity = buy_order.quantity

     benefit = BigDecimal.new(quantity * (sell_price - buy_price)).floor(8)
     percentage = BigDecimal.new((((sell_price * 100) / buy_price) - 100)).floor(2)

     {benefit: benefit, percentage: percentage}
    end
  end
end