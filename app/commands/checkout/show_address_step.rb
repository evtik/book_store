module Checkout
  class ShowAddressStep < BaseCommand
    def self.build
      new(Cart::CalculateCartTotals.build,
          Checkout::BuildOrder.build,
          Checkout::InitializeOrder.build,
          Common::GetCountries.build)
    end

    def initialize(*args)
      @get_totals, @builder, @initializer, @get_countries = args
    end

    def call(session, _flash)
      return publish(:denied, cart_path) if session[:cart].blank?
      totals = @get_totals.call(session)
      session[:items_total], session[:order_subtotal] = totals
      publish(
        :ok,
        order: @builder.call(session) || @initializer.call(session),
        countries: @get_countries.call
      )
    end
  end
end
