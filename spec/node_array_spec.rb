# frozen_string_literal: true

require_relative '../lib/node_array'

describe NodeArray do
  subject(:node_array) { described_class.new }

  describe '#to_s' do
    context "when there's a NodeArray of characters" do
      before do
        # Simulating Nodes in the NodeArray
        node_array.push('A')
        node_array.push(' ')
        node_array.push('V')
        node_array.push('a')
        node_array.push('l')
        node_array.push('u')
        node_array.push('e')
      end

      it 'return string concatenation of all values' do
        value = 'A Value'
        result = node_array.to_s

        expect(result).to eq(value)
      end
    end
  end
end
