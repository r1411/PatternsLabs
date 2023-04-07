# frozen_string_literal: true

class DataTable
  attr_reader :rows_count, :cols_count

  # Конструктор, принимает 2D Array
  def initialize(table)
    self.rows_count = table.size
    max_cols = 0
    table.each { |row| max_cols = row.size if row.size > max_cols }
    self.cols_count = max_cols
    self.table = table
  end

  # Получить значение в ячейке [row, col]
  def get_item(row, col)
    return nil if row >= rows_count
    return nil if col >= cols_count

    table[row][col].dup
  end

  def to_2d_array
    table.dup
  end

  def to_s
    "DataTable (#{rows_count}x#{cols_count})"
  end

  private

  attr_accessor :table
  attr_writer :rows_count, :cols_count
end
