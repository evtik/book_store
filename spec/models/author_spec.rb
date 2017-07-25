describe Author, type: :model do
  context 'association' do
    it { is_expected.to have_and_belong_to_many(:books) }
  end

  context 'first name' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to allow_value('John').for(:first_name) }
    it { is_expected.to allow_value('John-Patrick').for(:first_name) }
    it { is_expected.to allow_value('John Patrick').for(:first_name) }
    it { is_expected.to allow_value('Марійка').for(:first_name) }
    it { is_expected.not_to allow_value('John5').for(:first_name) }
    it { is_expected.not_to allow_value('J%hn').for(:first_name) }
  end

  context 'last name' do
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to allow_value('Coolige').for(:last_name) }
    it { is_expected.to allow_value('Calvin Coolige').for(:last_name) }
    it { is_expected.to allow_value('Нелупибатько').for(:last_name) }
    it { is_expected.to allow_value('Ґут-Кульчицький').for(:last_name) }
    it { is_expected.not_to allow_value('Петренк0').for(:last_name) }
    it { is_expected.not_to allow_value('Д№аниленко').for(:last_name) }
  end

  context 'description' do
    include_examples 'description'
  end
end
