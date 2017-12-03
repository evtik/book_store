feature 'Admin Order index page' do
  include_examples 'not authorized', :admin_orders_path

  let(:admin_user) { create(:admin_user) }
  let(:ar_prefix) { 'activerecord.attributes.order.state.' }
  let(:aa_prefix) { 'active_admin.resource.index.order.' }

  context 'with admin' do
    context 'orders list' do
      background do
        shipment = create(:shipment)
        Order.aasm.states.map(&:name).each_with_index do |state, index|
          create_list(:order, index + 1, shipment: shipment, user: admin_user,
                                         state: state, subtotal: 10.0)
        end
        login_as(admin_user, scope: :user)
        visit admin_orders_path
      end

      scenario 'shows list of orders with appropriate states' do
        {
          /r0000/i => 15,
          t("#{ar_prefix}canceled").upcase => 5,
          t("#{ar_prefix}delivered").upcase => 4,
          t("#{ar_prefix}in_delivery").upcase => 3,
          t("#{ar_prefix}in_queue").upcase => 2,
          t("#{ar_prefix}in_progress").upcase => 1
        }.each { |key, value| expect(page).to have_text(key, count: value) }
      end

      scenario 'shows appropriate state change buttons' do
        {
          t("#{aa_prefix}cancel") => 3,
          t("#{aa_prefix}complete") => 3,
          t("#{aa_prefix}deliver") => 2,
          t("#{aa_prefix}queue") => 1
        }.each do |key, value|
          expect(page).to have_css('.button', text: key, count: value)
        end
      end

      context 'fiters' do
        scenario 'shows order list filters' do
          [
            'All (15)',
            t("#{aa_prefix}in_progress") + ' (6)',
            t("#{aa_prefix}delivered") + ' (4)',
            t("#{aa_prefix}canceled") + ' (5)'
          ].each do |text|
            expect(page).to have_css('.table_tools_button', text: text)
          end
        end

        scenario "click on 'in progress' filters out other orders" do
          first('.table_tools_button', text: t("#{aa_prefix}in_progress")).click
          [
            t("#{ar_prefix}canceled").upcase,
            t("#{ar_prefix}delivered").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end

        scenario "click on 'delivered' filters out other orders" do
          first('.table_tools_button', text: t("#{aa_prefix}delivered")).click
          [
            t("#{ar_prefix}in_progress").upcase,
            t("#{ar_prefix}canceled").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end

        scenario "click on 'canceled' filters out other orders" do
          first('.table_tools_button', text: t("#{aa_prefix}canceled")).click
          [
            t("#{ar_prefix}in_progress").upcase,
            t("#{ar_prefix}delivered").upcase
          ].each { |state| expect(page).not_to have_text(state) }
        end
      end
    end

    context 'aasm actions' do
      let(:shipment) { create(:shipment) }

      background { login_as(admin_user, scope: :user) }

      shared_examples 'order action' do |params|
        scenario "click on '#{params[:action]}' changes order state "\
          "to '#{params[:next_state]}'" do
          click_on(t("#{aa_prefix}#{params[:action]}"))

          expect(page).not_to have_text(
            t("#{ar_prefix}#{params[:state]}").upcase
          )

          expect(page).not_to have_css(
            '.button', text: t("#{aa_prefix}#{params[:action]}")
          )

          expect(page).to have_text(
            t("#{ar_prefix}#{params[:next_state]}").upcase
          )

          if params[:next_action]
            expect(page).to have_css(
              '.button', text: t("#{aa_prefix}#{params[:next_action]}")
            )
          end
        end
      end

      shared_examples 'cancel order action' do |params|
        scenario "click on 'cancel' changes order state to 'canceled'" do
          click_on(t("#{aa_prefix}cancel"))

          expect(page).not_to have_text(
            t("#{ar_prefix}#{params[:state]}").upcase
          )

          expect(page).not_to have_css(
            '.button', text: t("#{aa_prefix}#{params[:action]}")
          )

          expect(page).not_to have_css(
            '.button', text: t("#{aa_prefix}cancel")
          )

          expect(page).to have_text(
            t("#{ar_prefix}canceled").upcase
          )
        end
      end

      context "'in progress' order" do
        before do
          create(:order, shipment: shipment, user: admin_user, subtotal: 10.0)
          visit admin_orders_path
        end

        params = { state: 'in_progress', next_state: 'in_queue',
                   action: 'queue', next_action: 'deliver' }

        include_examples 'order action', params
        include_examples 'cancel order action', params
      end

      context "'in queue' order" do
        before do
          create(:order, state: 'in_queue', shipment: shipment,
                         user: admin_user, subtotal: 10.0)
          visit admin_orders_path
        end

        params = { state: 'in_queue', next_state: 'in_delivery',
                   action: 'deliver', next_action: 'complete' }

        include_examples 'order action', params
        include_examples 'cancel order action', params
      end

      context "'in delivery' order" do
        before do
          create(:order, state: 'in_delivery', shipment: shipment,
                         user: admin_user, subtotal: 10.0)
          visit admin_orders_path
        end

        params = { state: 'in_delivery', next_state: 'delivered',
                   action: 'complete' }

        include_examples 'order action', params
      end
    end
  end
end
