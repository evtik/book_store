shared_context 'aasm order variables' do
  given(:aasm_states) { Order.aasm.states.map(&:name) }
  given(:aasm_events) { Order.aasm.events.map(&:name) }
end
