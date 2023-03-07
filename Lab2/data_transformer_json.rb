# frozen_string_literal: true

require_relative 'data_transformer_base'
require 'json'

class DataTransformerJSON < DataTransformerBase
  public_class_method :new

  def str_to_hash_list(str)
    JSON.parse(str, { symbolize_names: true })
  end

  def hash_list_to_str(hash_list)
    JSON.pretty_generate(hash_list)
  end
end
