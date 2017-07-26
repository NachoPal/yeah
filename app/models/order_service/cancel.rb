module OrderService
  class Cancel

    def fire!(sell_order)
        sell_order.destroy
    end
  end
end