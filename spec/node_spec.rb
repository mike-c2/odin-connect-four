# frozen_string_literal: true

require_relative '../lib/node'

describe Node do
  let(:value) { 'Some value' }
  subject(:node) { described_class.new(value) }

  describe '#to_s' do
    it "returns the Node's value as a string" do
      expect(node.to_s).to eq(value)
    end
  end

  describe '#==' do
    context 'when nodes have different values' do
      let(:other_value) { 'Other value' }
      let(:other_node) { described_class.new(other_value) }

      it 'returns false' do
        expect(node).not_to eq(other_node)
      end
    end

    context 'when nodes have same values' do
      let(:other_node) { described_class.new(value) }

      it 'returns true' do
        expect(node).to eq(other_node)
      end
    end
  end
end
