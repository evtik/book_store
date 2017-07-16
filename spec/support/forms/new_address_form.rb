class NewAddressForm
  include Capybara::DSL

  def initialize(parent, type)
    @parent = parent
    @type = type
  end

  def fill_in_form(params)
    fill_in("#{@parent}[#{@type}][first_name]", with: params[:first_name])
    fill_in("#{@parent}[#{@type}][last_name]", with: params[:last_name])
    fill_in("#{@parent}[#{@type}][street_address]", with: params[:street_address])
    fill_in("#{@parent}[#{@type}][city]", with: params[:city])
    fill_in("#{@parent}[#{@type}][zip]", with: params[:zip])
    select(params[:country], from: "#{@parent}[#{@type}][country]")
    fill_in("#{@parent}[#{@type}][phone]", with: params[:phone])
  end
end
