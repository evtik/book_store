module BatchActionsHelpers
  include Capybara::DSL

  def check_batch_all
    check('collection_selection_toggle_all')
  end

  def check_batch_items(*items)
    items.each { |item| check("batch_action_item_#{item}") }
  end

  def click_batch_delete
    click_link(t('active_admin.batch_actions.button_label'))
    click_link(t('active_admin.batch_actions.action_label',
                 title: t('active_admin.batch_actions.labels.destroy')))
    click_button('OK')
  end

  def batch_destroyed_label(count, model)
    t('active_admin.batch_actions.succesfully_destroyed.other',
      count: count, plural_model: model)
  end
end
