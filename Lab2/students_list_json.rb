# frozen_string_literal: true

require_relative 'students_list_base'
require 'json'

class StudentsListJSON < StudentsListBase
  public_class_method :new

  protected

  def str_to_hash_list(str)
    JSON.parse(str, { symbolize_names: true })
  end

  def hash_list_to_str(hash_list)
    JSON.pretty_generate(hash_list)
  end
end
