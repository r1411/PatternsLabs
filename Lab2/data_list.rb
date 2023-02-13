# frozen_string_literal: true

class DataList
  # Это "абстрактный" класс
  private_class_method :new

  attr_reader :selected_id

  # Конструктор, принимает массив любых объектов
  def initialize(objects)
    self.objects = objects
  end

  # Выбрать элемент по номеру
  def select_element(id)
    self.selected_id = id < objects.size ? id : nil
  end

  # Имена атрибутов объектов по порядку. Переопределить в наследниках
  def column_names
    []
  end

  # Получить DataTable со всеми элементами. Переопределить в наследниках
  def data_table
    DataTable.new([])
  end

  private

  attr_accessor :objects
  attr_writer :selected_id
end
