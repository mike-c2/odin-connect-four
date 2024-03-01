# frozen_string_literal: true

require_relative '../lib/connect_four'

describe ConnectFour do
  subject(:connect_four) { described_class.new(grid) }
  let(:grid) { double }
  let(:player_marker) { 'X' }
  let(:opponent_marker) { 'O' }
  let(:blank) { ' ' }

  describe '#winner?' do
    context 'when no one has moved yet' do
      let(:all_lines) do
        Array.new(100, blank * 10)
      end

      before do
        allow(grid).to receive(:all_majors).and_return(all_lines)
      end

      it 'there is no winner' do
        is_expected.not_to be_winner(player_marker)
      end
    end

    context 'when there is no 4 in a row' do
      let(:all_lines) do
        Array.new(100, "#{player_marker}#{opponent_marker}" * 10)
      end

      before do
        allow(grid).to receive(:all_majors).and_return(all_lines)
      end

      it 'there is no winner' do
        is_expected.not_to be_winner(player_marker)
      end
    end

    context 'when there is only 3 in a row' do
      let(:all_lines) do
        some_lines = Array.new(50, "#{player_marker}#{opponent_marker}" * 10)
        all_lines = some_lines.dup
        all_lines.push("#{player_marker * 3}#{opponent_marker * 2}")
        all_lines + some_lines.dup
      end

      before do
        allow(grid).to receive(:all_majors).and_return(all_lines)
      end

      it 'there is no winner' do
        is_expected.not_to be_winner(player_marker)
      end
    end

    context 'when there is a 4 in a row' do
      let(:all_lines) do
        some_lines = Array.new(50, "#{player_marker}#{opponent_marker}" * 10)
        all_lines = some_lines.dup
        all_lines.push("#{player_marker * 4}#{opponent_marker * 3}")
        all_lines + some_lines
      end

      before do
        allow(grid).to receive(:all_majors).and_return(all_lines)
      end

      it 'there is a winner' do
        is_expected.to be_winner(player_marker)
      end
    end
  end

  describe '#done?' do
    context 'when no one has moved yet' do
      let(:num_columns) { 7 }
      let(:num_rows) { 6 }

      let(:columns) do
        Array.new(num_columns, blank * num_rows)
      end

      before do
        allow(grid).to receive(:column_major).and_return(columns)
      end

      it 'game is not done' do
        is_expected.not_to be_done
      end
    end

    context 'when there is one blank left' do
      let(:columns) do
        some_columns = Array.new(3) { "#{player_marker}#{opponent_marker}" * 3 }
        all_columns = some_columns.dup
        all_columns.push("#{player_marker * 3}#{opponent_marker * 2}#{blank}")
        all_columns + some_columns
      end

      before do
        allow(grid).to receive(:column_major).and_return(columns)
      end

      it 'game is not done' do
        is_expected.not_to be_done
      end
    end

    context 'when there are no blanks left' do
      let(:num_columns) { 7 }

      let(:columns) do
        Array.new(num_columns) { "#{player_marker}#{opponent_marker}" * 3 }
      end

      before do
        allow(grid).to receive(:column_major).and_return(columns)
      end

      it 'game is done' do
        is_expected.to be_done
      end
    end
  end

  describe '#played?' do
    let(:blank_node) { double('blank_node') }
    let(:already_played_node) { double('already_played_node') }
    let(:num_columns) { 7 }
    let(:column_length) { 6 }
    let(:available_column_index) { 3 }
    let(:available_node_index) { 4 }
    let(:columns) do
      game_columns = Array.new(num_columns) do
        Array.new(column_length, already_played_node)
      end

      game_columns[available_column_index].fill(blank_node, available_node_index)
      game_columns
    end

    let(:available_column) { columns[available_column_index] }

    before do
      allow(grid).to receive(:column_major).and_return(columns)
      allow(Node).to receive(:new).and_return(blank_node)
      allow(blank_node).to receive(:value=).with(player_marker)
    end

    context 'when column_index is set to non-existent column' do
      it 'returns false' do
        is_expected.not_to be_played(player_marker, num_columns + 1)
      end
    end

    context 'when column_index is set to column that is full' do
      it 'returns false' do
        is_expected.not_to be_played(player_marker, available_column_index - 1)
      end

      context 'when column_index is set to column that is open' do
        it 'the first available blank node in that column is selected' do
          expect(available_column).to receive(:find_index).with(blank_node).and_return(available_node_index).once

          connect_four.played?(player_marker, available_column_index)
        end

        it 'the blank node gets set to the player marker' do
          connect_four.played?(player_marker, available_column_index)

          expect(blank_node).to have_received(:value=).with(player_marker).once
        end
      end
    end
  end

  describe '#reset' do
    before do
      allow(grid).to receive(:clear).with(blank)
    end

    it 'clear the grid' do
      connect_four.reset
      expect(grid).to have_received(:clear).with(blank).once
    end
  end
end
