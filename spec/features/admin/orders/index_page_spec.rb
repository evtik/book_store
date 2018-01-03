feature 'Admin Order index page' do
  include_context 'aasm order variables'

  include_examples 'not authorized', :admin_orders_path

  given(:admin_user) { create(:admin_user) }

  context 'with admin' do
    context 'redirecting to order show page' do
      scenario 'click order link forwards to show page', use_selenium: true do
        create(:order, shipment: build(:shipment),
                       user: admin_user,
                       addresses: build_list(:address, 1),
                       credit_card: build(:credit_card),
                       subtotal: 20.0)
        login_as(admin_user, scope: :user)
        visit admin_orders_path
        click_link('R00000001')
        expect(page).to have_text("#{t('activerecord.models.order.one')} #1")
      end
    end

    context 'orders list' do
      background do
        shipment = create(:shipment)
        aasm_states.each_with_index do |state, index|
          create_list(:order, index + 1, shipment: shipment, user: admin_user,
                                         state: state, subtotal: 10.0)
        end
        login_as(admin_user, scope: :user)
        visit admin_orders_path
      end

      scenario 'shows list of orders with appropriate states',
               use_selenium: true do
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

      context 'filters' do
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

        include_examples 'active admin filters',
                         filters: %i(in_progress delivered canceled),
                         entity: :orders
      end
    end

    context 'aasm actions' do
      background { login_as(admin_user, scope: :user) }

      params = AASMHelper.order_config.merge(
        path_helper: :admin_orders_path,
        resource_path: false
      )

      include_examples 'aasm actions', params do
        given(:entity) do
          create(:order, shipment: build(:shipment), user: admin_user,
                         subtotal: 10.0)
        end
      end
    end
  end
end
