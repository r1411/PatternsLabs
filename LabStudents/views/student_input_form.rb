# frozen_string_literal: true

require 'glimmer-dsl-libui'
require './LabStudents/controllers/student_input_form_controller'
require './LabStudents/models/student_base'
require 'win32api'

class StudentInputForm
  include Glimmer

  def initialize(existing_student = nil)
    @existing_student = existing_student.to_hash unless existing_student.nil?
    @controller = StudentInputFormController.new(self, existing_student)
  end

  def on_create
    @controller.on_view_created
  end

  def create
    @root_container = window('Универ', 300, 150) {
      resizable false

      vertical_box {
        @student_form = form {
          stretchy false

          fields = [[:last_name, 'Фамилия', false], [:first_name, 'Имя', false], [:father_name, 'Отчество', false], [:git, 'Гит', true], [:telegram, 'Телеграм', true], [:email, 'Почта', true], [:phone, 'Телефон', true]]

          fields.each do |field|
            entry {
              label field[1]
              text @existing_student[field[0]] unless @existing_student.nil?

              read_only field[2] unless @existing_student.nil?
            }
          end
        }

        button('Сохранить') {
          stretchy false

          on_clicked {
            validate_and_save
          }
        }
      }
    }
    on_create
    @root_container
  end

  def validate_and_save
    input_git = @student_form.children[3].text.force_encoding("utf-8")
    input_tg = @student_form.children[4].text.force_encoding("utf-8")
    input_email = @student_form.children[5].text.force_encoding("utf-8")
    input_phone = @student_form.children[6].text.force_encoding("utf-8")

    input_git = nil if input_git.strip.empty?
    input_tg = nil if input_tg.strip.empty?
    input_email = nil if input_email.strip.empty?
    input_phone = nil if input_phone.strip.empty?

    begin
      stud = Student.new(
        @student_form.children[0].text.force_encoding("utf-8"),
        @student_form.children[1].text.force_encoding("utf-8"),
        @student_form.children[2].text.force_encoding("utf-8"),
        git: input_git,
        telegram: input_tg,
        email: input_email,
        phone: input_phone
      )
      @controller.save_student(stud)
      close
    rescue ArgumentError => e
      api = Win32API.new('user32', 'MessageBox', ['L', 'P', 'P', 'L'], 'I')
      api.call(0, e.message, 'Error', 0)
    end
  end

  def close
    @root_container.destroy
  end
end
