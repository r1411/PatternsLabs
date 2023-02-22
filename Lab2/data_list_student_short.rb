# frozen_string_literal: true

require_relative 'data_list'

class DataListStudentShort < DataList
  # Делаем приватный new предка публичным
  public_class_method :new

  def column_names
    %w[git contact last_name_and_initials]
  end

  protected

  def table_fields(obj)
    [obj.git, obj.contact, obj.last_name_and_initials]
  end
end
