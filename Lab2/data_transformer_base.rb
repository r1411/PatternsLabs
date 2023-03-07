# frozen_string_literal: true

class DataTransformerBase
  private_class_method :new

  protected

  def str_to_hash_list(str)
    raise NotImplementedError('Should be implemented in child')
  end

  def hash_list_to_str(hash_list)
    raise NotImplementedError('Should be implemented in child')
  end
end
