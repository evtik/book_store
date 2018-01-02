module AASMHelper
  class << self
    def order_state_events_set
      {
        in_progress: [:queue, :cancel],
        in_queue: [:deliver, :cancel],
        in_delivery: [:complete],
        delivered: nil,
        canceled: nil,
        nil: nil
      }
    end

    def order_config
      {
        last_action: :cancel,
        last_state: :canceled,
        entity_label: :order
      }
    end
  end
end
