shared_context 'aasm review variables' do
  given(:aasm_states) { Review.aasm.states.map(&:name) }
  given(:aasm_events) { Review.aasm.events.map(&:name) }
  given(:ar_prefix) { 'activerecord.attributes.review.state.' }
  given(:aa_prefix) { 'active_admin.resource.index.review.' }
end
