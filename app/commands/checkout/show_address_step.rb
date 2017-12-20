module Checkout
  class ShowAddressStep < BaseCommand
    def self.build
      new(Checkout::BuildOrder.build,
          Checkout::InitializeOrder.build,
          Common::GetCountries.build)
    end

    def initialize(*args)
      @builder, @initializer, @get_countries = args
    end

    def call(session, _flash)
      return publish(:denied, cart_path) if session[:cart].blank?
      publish(
        :ok,
        order: @builder.call(session) || @initializer.call(session),
        countries: @get_countries.call
      )
    end
  end
end
