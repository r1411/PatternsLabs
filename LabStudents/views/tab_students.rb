# frozen_string_literal: true

require 'glimmer-dsl-libui'
require './LabStudents/controllers/tab_students_controller'
require './LabStudents/events/event_manager'
require './LabStudents/events/impl/event_update_students_table'

class TabStudents
  include Glimmer

  STUDENTS_PER_PAGE = 20

  def initialize
    @controller = TabStudentsController.new(self)
    @current_page = 1
  end

  def on_create
    EventManager.subscribe(self, EventUpdateStudentsTable)
    @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
  end

  def on_event(event)
    case event
    when EventUpdateStudentsTable
      puts event.new_table.to_2d_array
      # TODO: обновление столбцов сделать динамически здесь
      @table.model_array = event.new_table.to_2d_array
    end
  end

  def create
    root_container = horizontal_box {
      # Секция 1
      vertical_box {
        stretchy false

        form {
          stretchy false

          @filter_last_name_initials = entry {
            label 'Фамилия И. О.'
          }

          @filters = {}
          fields = [[:git, 'Гит'], [:email, 'Почта'], [:phone, 'Телефон'], [:telegram, 'Телеграм']]

          fields.each do |field|
            @filters[field[0]] = {}

            @filters[field[0]][:combobox] = combobox {
              label "#{field[1]} имеется?"
              items ['Не важно', 'Есть', 'Нет']
              selected 0

              on_selected do
                if @filters[field[0]][:combobox].selected == 1
                  @filters[field[0]][:entry].read_only = false
                else
                  @filters[field[0]][:entry].text = ''
                  @filters[field[0]][:entry].read_only = true
                end
              end
            }

            @filters[field[0]][:entry] = entry {
              label field[1]
              read_only true
            }
          end
        }
      }

      # Секция 2
      vertical_box {
        @table = refined_table(
          table_editable: false,
          table_columns: {
            '#' => :text,
            'Гит' => :text,
            'Контакт' => :text,
            'Фамилия И. О' => :text
          }
        )

        @pages = horizontal_box {
          stretchy false

          button('1')
          button('2')
          button('3')
          label('...') { stretchy false }
          button('15')
        }
      }

      # Секция 3
      vertical_box {
        stretchy false

        button('Добавить') { stretchy false }
        button('Изменить') { stretchy false }
        button('Удалить') { stretchy false }
        button('Обновить') { stretchy false }
      }
    }
    on_create
    root_container
  end
end
