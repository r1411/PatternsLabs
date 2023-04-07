# frozen_string_literal: true

class EventUpdateStudentsTable
  def initialize(new_table, column_names)
    @new_table = new_table.dup
    @column_names = column_names.dup
  end

  attr_reader :new_table, :column_names
end
