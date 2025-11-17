# frozen_string_literal: true

RSpec.describe Date do
  describe '#period_format?' do
    [
      condition: 'valid integer', value: 202511,
      condition: 'valid string', value: '202511',
    ].each do |caze|
      context "when the date is #{caze[:condition]}" do
        it 'returns true' do
          expect(Date.period_format?(caze[:value])).to be true
        end
      end
    end

    [
      { condition: 'only year', value: '2025' },
      { condition: 'month with empty', value: '2025 5' },
      { condition: 'a string like a date', value: '20251010' },
      { condition: 'nil', value: nil },
      { condition: 'empty', value: '' },
      { condition: 'invalid', value: 'not a number' },
      { condition: 'a string from a Struct', value: Struct.new(:year, :month).new(2025, 11).to_s },
    ].each do |caze|
      context "when the date is #{caze[:condition]}" do
        it 'returns false' do
          expect(Date.period_format?(caze[:value])).to be false
        end
      end
    end
  end

  describe '#parse_period_safe' do
    context 'when the period can be parsed' do
      it 'returns the date' do
        expect(Date.parse_period_safe('202511')).to eq Date.new(2025, 11, 1)
      end
    end

    context 'when the period cannot be parsed' do
      it 'returns nil' do
        expect(Date.parse_period_safe('20251115')).to be nil
      end
    end

    context 'when the period cannot be parsed and the default value is specified' do
      it 'returns the specified value' do
        expect(Date.parse_period_safe('20251115', Date.new(2025, 5, 1))).to eq Date.new(2025, 5, 1)
      end
    end
  end

  describe '#parse_period!' do
    context 'when the period can be parsed' do
      it 'returns the date' do
        expect(Date.parse_period!('202511')).to eq Date.new(2025, 11, 1)
      end
    end

    context 'when the period cannot be parsed' do
      it 'raises an error' do
        expect { Date.parse_period!('2025-01-01') }.to raise_error(ArgumentError)
      end
    end
  end
end
