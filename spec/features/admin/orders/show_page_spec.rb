feature 'Admin show Order page' do
  include_examples 'not authorized', :admin_order_path, 1

  context 'with admin' do
    given(:admin_user) { create(:admin_user) }
    given!(:books) { create_list(:book_with_authors_and_materials, 4) }
    given(:shipment) { create(:shipment, price: 12.99) }
    given(:credit_card) { create(:credit_card) }
    given(:coupon) { create(:coupon) }
    given!(:order) do
      create(:order,
             user: admin_user,
             shipment: shipment,
             addresses: [
               build(:address),
               build(:address, address_type: 'shipping', country: 'Chad')
             ],
             order_items: build_list(:order_item_with_book_id_cycled, 4),
             credit_card: credit_card,
             coupon: coupon,
             subtotal: 35.16)
    end

    background do
      login_as(admin_user, scope: :user)
    end

    context 'order details' do
      scenario 'shows order details' do
        visit admin_order_path(order)
        expect(page).to have_link(admin_user.email)
        books.map(&:title) + [4.00, '10%', 12.99, 35.16, 48.15] + [
          t('checkout.address.billing_address'),
          'Italy',
          t('checkout.address.shipping_address'),
          'Chad',
          t('checkout.payment.credit_card'),
          credit_card.number.scan(/(....)/).join(' ')
        ].each { |text| expect(page).to have_text(text) }
      end
    end

    context 'aasm actions' do
      given(:ar_prefix) { 'activerecord.attributes.order.state.' }
      given(:aa_prefix) { 'active_admin.resource.index.order.' }
      given(:aasm_states) { Order.aasm.states.map(&:name) }
      given(:aasm_events) { Order.aasm.events.map(&:name) }

      shared_examples 'state labels' do |current_state|
        scenario 'has correct state label' do
          expect(page).to have_text(t("#{ar_prefix}#{current_state}").upcase)

          (aasm_states - [current_state]).each do |state|
            expect(page).not_to have_text(t("#{ar_prefix}#{state}").upcase)
          end
        end
      end

      shared_examples 'state buttons' do |allowed_actions|
        scenario 'has correct change state buttons' do
          allowed_actions ||= []

          allowed_actions.each do |action|
            expect(page).to have_link(t("#{aa_prefix}#{action}"))
          end

          (aasm_events - allowed_actions).each do |action|
            expect(page).not_to have_link(t("#{aa_prefix}#{action}"))
          end
        end
      end

      {
        in_progress: [:queue, :cancel],
        in_queue: [:deliver, :cancel],
        in_delivery: [:complete],
        delivered: nil,
        canceled: nil,
        nil: nil
      }.each_cons(2) do |curr, nxt|
        current_state = curr[0]
        next_state = nxt[0]
        allowed_actions = curr[1]
        next_allowed_actions = nxt[1]

        context "order in #{current_state} state", use_selenium: true do
          before do
            order.state = current_state
            order.save
            visit admin_order_path(order)
          end

          include_examples 'state labels', current_state
          include_examples 'state buttons', allowed_actions

          allowed_actions&.each do |action|
            if action == :cancel
              next_state = :canceled
              next_allowed_actions = nil
            end

            context "click on #{action} changes state to #{next_state}" do
              before { click_on(t("#{aa_prefix}#{action}")) }

              include_examples 'state labels', next_state
              include_examples 'state buttons', next_allowed_actions
            end
          end
        end
      end
    end
  end
end
