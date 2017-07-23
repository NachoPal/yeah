module OrderService
  class Cancel

    def fire!(sell_order)
        sell_order.first.destroy
    end
  end
end