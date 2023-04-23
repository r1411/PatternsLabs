# frozen_string_literal: true

require 'glimmer-dsl-libui'
require './LabStudents/controllers/tab_students_controller'
require './LabStudents/views/student_input_form'

class TabStudents
  include Glimmer

  STUDENTS_PER_PAGE = 20

  def initialize
    @controller = TabStudentsController.new(self)
    @current_page = 1
    @total_count = 0
  end

  def on_create
    @controller.on_view_created
    @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
  end

  # Метод наблюдателя datalist
  def on_datalist_changed(new_table)
    arr = new_table.to_2d_array
    arr.map do |row|
      row[3] = [row[3][:value], contact_color(row[3][:type])] unless row[3].nil?
    end
    @table.model_array = arr
  end

  def update_student_count(new_cnt)
    @total_count = new_cnt
    @page_label.text = "#{@current_page} / #{(@total_count / STUDENTS_PER_PAGE.to_f).ceil}"
  end

  def contact_color(type)
    case type
    when 'telegram'
      '#00ADB5'
    when 'email'
      '#F08A5D'
    when 'phone'
      '#B83B5E'
    else
      '#000000'
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
          filter: lambda do |row_hash, query|
            utf8_query = query.force_encoding("utf-8")
            row_hash['Фамилия И. О'].include?(utf8_query)
          end,
          table_columns: {
            '#' => :text,
            'Фамилия И. О' => :text,
            'Гит' => :text,
            'Контакт' => :text_color
          },
          per_page: STUDENTS_PER_PAGE
        )

        @pages = horizontal_box {
          stretchy false

          button("<") {
            stretchy true

            on_clicked do
              @current_page = [@current_page - 1, 1].max
              @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
            end

          }
          @page_label = label("...") { stretchy false }
          button(">") {
            stretchy true

            on_clicked do
              @current_page = [@current_page + 1, (@total_count / STUDENTS_PER_PAGE.to_f).ceil].min
              @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
            end
          }
        }
      }

      # Секция 3
      vertical_box {
        stretchy false

        button('Добавить') {
          stretchy false

          on_clicked {
            @controller.show_modal_add
          }
        }
        button('Изменить') {
          stretchy false

          on_clicked {
            @controller.show_modal_edit(@current_page, STUDENTS_PER_PAGE, @table.selection) unless @table.selection.nil?
          }
        }
        button('Удалить') { stretchy false }
        button('Обновить') {
          stretchy false

          on_clicked {
            @controller.refresh_data(@current_page, STUDENTS_PER_PAGE)
          }
        }
      }
    }
    on_create
    root_container
  end
end
