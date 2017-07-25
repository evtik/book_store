shared_examples 'description' do
  it { is_expected.to validate_presence_of(:description) }

  it do
    is_expected.to allow_value(
      'Some **weird** *long* description'
    ).for(:description)
  end

  it { is_expected.to allow_value('Довільний опис').for(:description) }

  it do
    is_expected.not_to allow_value(
      'Some <weird> long; description'
    ).for(:description)
  end
end
