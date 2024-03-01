# frozen_string_literal: true

require_relative '../lib/grid'

describe Grid do
  subject(:row_major) do
    described_class.build_row_major(initial_value, rows_count, columns_count)
  end

  let(:initial_value) { 'X' }
  let(:rows_count) { 6 }
  let(:columns_count) { 7 }

  before do
    node_array = Array.new(columns_count, initial_value)
    allow(NodeArray).to receive(:new).with(columns_count).and_return(node_array)
  end

  describe '.build_row_major' do
    context 'when the 2-dimensional Array is returned' do
      it 'has 6 rows' do
        expect(row_major.length).to eq(rows_count)
      end

      it 'is frozen' do
        expect(row_major).to be_frozen
      end
    end

    context 'with each NodeArray in the returned Array' do
      it 'consists of 7 elements' do
        all_rows_length = row_major.map(&:length)
        expect(all_rows_length).to all(eq(columns_count))
      end

      it 'is frozen' do
        expect(row_major).to all(be_frozen)
      end

      it 'has the correct initial values' do
        all_values = row_major.map(&:join)
        expected_value = initial_value * columns_count
        expect(all_values).to all(eq(expected_value))
      end
    end
  end

  describe '.derive_column_major' do
    subject(:column_major) do
      described_class.derive_column_major(node_array)
    end

    let(:node_array) do
      Array.new(6) { Array.new(7, 'X') }
    end

    before do
      return_list = []
      7.times { return_list << [] }
      allow(NodeArray).to receive(:new).and_return(*return_list)
    end

    context 'when the transposed 2-dimensional Array is returned' do
      it 'has 7 columns' do
        expect(column_major.length).to eq(columns_count)
      end

      it 'is frozen' do
        expect(column_major).to be_frozen
      end
    end

    context 'with each NodeArray in the returned transposed Array' do
      it 'consists of 6 elements' do
        all_columns_length = column_major.map(&:length)
        expect(all_columns_length).to all(eq(rows_count))
      end

      it 'is frozen' do
        expect(column_major).to all(be_frozen)
      end

      it 'has the correct initial values' do
        all_values = column_major.map(&:join)
        expected_value = initial_value * rows_count
        expect(all_values).to all(eq(expected_value))
      end
    end
  end

  describe '.derive_uphill_diagonal_major' do
    subject(:uphill_diagonal_major) do
      described_class.derive_uphill_diagonal_major(input_arrays)
    end

    let(:input_arrays) do
      [%w[A1 B2 C3 D4 E5 F6 G7].freeze,
       %w[B1 C2 D3 E4 F5 G6 H7].freeze,
       %w[C1 D2 E3 F4 G5 H6 I7].freeze,
       %w[D1 E2 F3 G4 H5 I6 J7].freeze,
       %w[E1 F2 G3 H4 I5 J6 K7].freeze,
       %w[F1 G2 H3 I4 J5 K6 L7].freeze].freeze
    end

    let(:expected_arrays) do
      [%w[A1].freeze,
       %w[B1 B2].freeze,
       %w[C1 C2 C3].freeze,
       %w[D1 D2 D3 D4].freeze,
       %w[E1 E2 E3 E4 E5].freeze,
       %w[F1 F2 F3 F4 F5 F6].freeze,
       %w[G2 G3 G4 G5 G6 G7].freeze,
       %w[H3 H4 H5 H6 H7].freeze,
       %w[I4 I5 I6 I7].freeze,
       %w[J5 J6 J7].freeze,
       %w[K6 K7].freeze,
       %w[L7].freeze].freeze
    end

    before do
      return_list = expected_arrays.map { [] }
      allow(NodeArray).to receive(:new).and_return(*return_list)
    end

    context 'when the uphill diagonal major arrays is returned' do
      it 'is equal to the expected uphill diagonal array' do
        is_expected.to eq(expected_arrays)
      end

      it 'is frozen' do
        is_expected.to be_frozen
      end
    end

    context 'with each NodeArray in the returned uphill diagonal Array' do
      it 'is frozen' do
        is_expected.to all(be_frozen)
      end
    end
  end

  describe '.derive_downhill_diagonal_major' do
    subject(:downhill_diagonal_major) do
      described_class.derive_downhill_diagonal_major(input_arrays)
    end

    let(:input_arrays) do
      [%w[G1 F1 E1 D1 C1 B1 A1].freeze,
       %w[H2 G2 F2 E2 D2 C2 B2].freeze,
       %w[I3 H3 G3 F3 E3 D3 C3].freeze,
       %w[J4 I4 H4 G4 F4 E4 D4].freeze,
       %w[K5 J5 I5 H5 G5 F5 E5].freeze,
       %w[L6 K6 J6 I6 H6 G6 F6].freeze].freeze
    end

    let(:expected_arrays) do
      [%w[A1].freeze,
       %w[B1 B2].freeze,
       %w[C1 C2 C3].freeze,
       %w[D1 D2 D3 D4].freeze,
       %w[E1 E2 E3 E4 E5].freeze,
       %w[F1 F2 F3 F4 F5 F6].freeze,
       %w[G1 G2 G3 G4 G5 G6].freeze,
       %w[H2 H3 H4 H5 H6].freeze,
       %w[I3 I4 I5 I6].freeze,
       %w[J4 J5 J6].freeze,
       %w[K5 K6].freeze,
       %w[L6].freeze].freeze
    end

    before do
      return_list = expected_arrays.map { [] }
      allow(NodeArray).to receive(:new).and_return(*return_list)
    end

    context 'when the downhill diagonal major arrays is returned' do
      it 'is equal to the expected downhill diagonal array' do
        is_expected.to eq(expected_arrays)
      end

      it 'is frozen' do
        is_expected.to be_frozen
      end
    end

    context 'with each NodeArray in the returned downhill diagonal Array' do
      it 'is frozen' do
        is_expected.to all(be_frozen)
      end
    end
  end

  describe '#to_s' do
    subject(:grid) { described_class.new }

    before do
      dummy_array = []
      allow(described_class).to receive(:build_row_major).and_return(dummy_array)
      allow(described_class).to receive(:derive_column_major).with(row_major).and_return(dummy_array)
      allow(described_class).to receive(:derive_uphill_diagonal_major).with(row_major).and_return(dummy_array)
      allow(described_class).to receive(:derive_downhill_diagonal_major).with(row_major).and_return(dummy_array)
      allow(grid).to receive(:derive_all_majors)
    end

    context 'when the grid is 1x1' do
      let(:grid_values) do
        [['A'].freeze].freeze
      end

      let(:expected_output) do
        <<~GRID
          -----
          | A |
          -----
        GRID
      end

      it 'return string table of 1x1 grid' do
        grid.instance_variable_set(:@row_major, grid_values)

        expect(grid.to_s).to eq(expected_output)
      end
    end

    context 'when the grid is 3x3' do
      let(:grid_values) do
        [[' ', 'A', 'B'].freeze,
         %w[C D E].freeze,
         %w[F G H].freeze].freeze
      end

      let(:expected_output) do
        <<~GRID
          -------------
          |   | A | B |
          -------------
          | C | D | E |
          -------------
          | F | G | H |
          -------------
        GRID
      end

      it 'return string table of 3x3 grid' do
        grid.instance_variable_set(:@row_major, grid_values)

        expect(grid.to_s).to eq(expected_output)
      end
    end

    context 'when the grid is 6x7' do
      let(:grid_values) do
        [[' ', ' ', ' ', ' ', ' ', ' ', ' '].freeze,
         [' ', ' ', ' ', ' ', 'A', ' ', ' '].freeze,
         ['B', ' ', 'C', 'D', 'E', 'F', 'G'].freeze,
         %w[H I J K L M N].freeze,
         %w[O P Q R S T U].freeze,
         %w[V W X Y Z 1 2].freeze].freeze
      end

      let(:expected_output) do
        <<~GRID
          -----------------------------
          |   |   |   |   |   |   |   |
          -----------------------------
          |   |   |   |   | A |   |   |
          -----------------------------
          | B |   | C | D | E | F | G |
          -----------------------------
          | H | I | J | K | L | M | N |
          -----------------------------
          | O | P | Q | R | S | T | U |
          -----------------------------
          | V | W | X | Y | Z | 1 | 2 |
          -----------------------------
        GRID
      end

      it 'return string table of 6x7 grid' do
        grid.instance_variable_set(:@row_major, grid_values)

        expect(grid.to_s).to eq(expected_output)
      end
    end
  end
end
