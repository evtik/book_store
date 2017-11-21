ActiveAdmin.register_page 'Dashboard' do
  menu priority: 1, label: proc { t('active_admin.dashboard') }

  content title: proc { t('active_admin.dashboard') } do
    columns do
      column do
        panel t('.recent_orders') do
          table_for Order.order('id desc').limit(10) do
            column(t('.order')) { |order| order.decorate.number }
            state_column :state
            column t('.date'), :created_at
            column t('.customer'), :user, sortable: :user_id
            column t('.total') do |order|
              number_to_currency order.subtotal + order.shipment.price
            end
          end
        end
      end
    end

    columns do
      column do
        panel t('.recent_reviews') do
          table_for Review.order('id desc').limit(10) do
            column(t('.book')) { |review| review.book.title }
            column t('.date'), :created_at
            column(t('.user')) { |review| review.user.email }
            state_column :state
          end
        end
      end
    end
  end
end
