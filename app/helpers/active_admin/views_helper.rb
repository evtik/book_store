module ActiveAdmin
  module ViewsHelper
    def order_aasm_links(order)
      actions = %w(queue deliver complete cancel).map do |action|
        next unless order.send("may_#{action}?")
        link_to(
          t(".order.#{action}"), send("order_#{action}_path", order.id),
          method: :put, class: "button #{action}_button"
        )
      end
      raw actions.join(' ')
    end

    def render_address(address)
      to_p_with_br(["#{address.first_name} #{address.last_name}",
                    address.street_address,
                    address.city,
                    address.country,
                    "Phone #{address.phone}"])
    end

    def render_credit_card(card)
      to_p_with_br([card.number.scan(/(....)/).join(' '),
                    card.cardholder,
                    card.month_year])
    end

    private

    def to_p_with_br(details)
      raw "<p>#{details.join('<br>')}</p>"
    end
  end
end
