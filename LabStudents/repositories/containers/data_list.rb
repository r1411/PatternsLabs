# frozen_string_literal: true

require './LabStudents/repositories/containers/data_table'
require './LabStudents/events/event_manager'
require './LabStudents/events/impl/event_update_students_table'

class DataList
  # Это "абстрактный" класс
  private_class_method :new

  attr_writer :objects

  # Конструктор, принимает массив любых объектов
  def initialize(objects)
    self.objects = objects
  end

  # Выбрать элемент по номеру
  def select_element(number)
    self.selected_num = number < objects.size ? number : nil
  end

  def selected_id
    objects[selected_num].id
  end

  # Получить DataTable со всеми элементами.
  def data_table
    result = []
    counter = 0
    objects.each do |obj|
      row = []
      row << counter
      row.push(*table_fields(obj))
      result << row
      counter += 1
    end
    DataTable.new(result)
  end

  # Добавить элементы в конец списка
  def replace_objects(objects)
    self.objects = objects.dup
    EventManager.notify(EventUpdateStudentsTable.new(data_table, column_names))
  end

  protected

  # Список значений полей для DataTable. Переопределить в наследниках
  def table_fields(_obj)
    []
  end

  # Имена атрибутов объектов по порядку. Переопределить в наследниках
  def column_names
    []
  end

  private

  attr_reader :objects
  attr_accessor :selected_num
end
