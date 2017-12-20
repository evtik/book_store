module Common
  class GetCountries < BaseService
    def call
      Country.all.map { |country| [country.name, country.country_code] }
    end
  end
end
