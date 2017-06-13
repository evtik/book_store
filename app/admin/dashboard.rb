ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

  content title: proc { I18n.t('active_admin.dashboard') } do
    columns do
      column do
        panel 'Recent orders' do
          table_for Order.order('id desc').limit(10) do
            column('Order') { |order| order.decorate.number }
            state_column :state
            column 'Date', :created_at
            column 'Customer', :user, sortable: :user_id
            column('Total') do |order|
              number_to_currency order.subtotal + order.shipment.price
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Recent reviews' do
          table_for Review.order('id desc').limit(10) do
            column('Book') { |review| review.book.title }
            column 'Date', :created_at
            column('User') { |review| review.user.email }
            state_column :state
          end
        end
      end
    end
  end
end
