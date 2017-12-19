module Checkout
  class ShowAddressStep < BaseCommand
    def self.build
      new(Checkout::BuildOrder.build, Checkout::InitializeOrder.build)
    end

    def initialize(*args)
      @builder, @initializer = args
    end

    def call(session, _flash)
      return publish(:denied, cart_path) if session[:cart].blank?
      publish(
        :ok,
        order: @builder.call(session) || @initializer.call(session),
        countries: (Country.all.map { |c| [c.name, c.country_code] })
      )
    end
  end
end
