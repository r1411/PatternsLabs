# frozen_string_literal: true

require_relative 'data_list'

class DataListStudentShort < DataList
  # Делаем приватный new предка публичным
  public_class_method :new

  def column_names
    %w[git contact last_name_and_initials]
  end

  def data_table
    result = []
    counter = 0
    objects.each do |obj|
      row = []
      row << counter
      row << obj.git
      row << obj.contact
      row << obj.last_name_and_initials
      result << row
      counter += 1
    end
    DataTable.new(result)
  end
end
