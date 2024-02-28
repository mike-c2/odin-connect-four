# frozen_string_literal: true

require_relative '../lib/node'
require_relative '../lib/node_array'

describe NodeArray do
  subject(:node_array) { described_class.new }

  describe '#to_s' do
    context "when there's a NodeArray of Nodes" do
      before do
        node_array.push(Node.new('A'))
        node_array.push(Node.new(' '))
        node_array.push(Node.new('V'))
        node_array.push(Node.new('a'))
        node_array.push(Node.new('l'))
        node_array.push(Node.new('u'))
        node_array.push(Node.new('e'))
      end

      it 'return string concatenation of all Node values' do
        value = 'A Value'
        result = node_array.to_s

        expect(result).to eq(value)
      end
    end
  end
end
