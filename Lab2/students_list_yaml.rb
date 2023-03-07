# frozen_string_literal: true

require_relative 'students_list_base'
require 'yaml'

class StudentsListYAML < StudentsListBase
  public_class_method :new

  protected

  def str_to_hash_list(str)
    YAML.safe_load(str).map { |h| h.transform_keys(&:to_sym) }
  end

  def hash_list_to_str(hash_list)
    hash_list.map { |h| h.transform_keys(&:to_s) }.to_yaml
  end
end
