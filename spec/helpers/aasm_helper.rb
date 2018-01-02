module AASMHelper
  ORDER_CONFIG = {
    set: {
      in_progress: [:queue, :cancel],
      in_queue: [:deliver, :cancel],
      in_delivery: [:complete],
      delivered: nil,
      canceled: nil,
      nil: nil
    },
    last_action: :cancel,
    last_state: :canceled,
    entity_label: :order
  }.freeze

  REVIEW_CONFIG = {
    set: {
      unprocessed: [:approve, :reject],
      approved: [:reject],
      rejected: nil,
      nil: nil
    },
    last_action: :reject,
    last_state: :rejected,
    entity_label: :review
  }.freeze

  class << self
    def order_config
      ORDER_CONFIG
    end

    def review_config
      REVIEW_CONFIG
    end
  end
end
