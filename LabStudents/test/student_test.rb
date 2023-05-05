# frozen_string_literal: true

require 'minitest/autorun'
require './LabStudents/models/student'
require 'json'

class StudentTest < Minitest::Test
  def setup
    @student = Student.new(
      'Иванов',
      'Иван',
      'Иванович',
      id: 10,
      phone: '79995554433',
      telegram: 'ivanushka',
      email: 'ivan@gmail.com',
      git: 'vanyadev'
    )
  end

  def teardown
    # Do nothing
  end

  def test_student_init_all_params_correct
    assert @student.last_name == 'Иванов'
    assert @student.first_name == 'Иван'
    assert @student.father_name == 'Иванович'
    assert @student.id == 10
    assert @student.phone == '79995554433'
    assert @student.telegram == 'ivanushka'
    assert @student.email == 'ivan@gmail.com'
    assert @student.git == 'vanyadev'
  end

  def test_student_empty_options
    Student.new('Сергеев', 'Сергей', 'Сергеевич')
  end

  def test_student_short_contact
    short_contact = @student.short_contact

    assert short_contact[:type] == :telegram
    assert short_contact[:value] == 'ivanushka'
  end

  def test_student_has_contacts
    assert @student.has_contacts? == true
  end

  def test_student_has_git
    assert @student.has_git? == true
  end

  def test_student_valid
    assert @student.valid? == true
  end

  def test_student_set_contacts
    stud = Student.new('Сараев', 'Поджог', 'Прометеевич')
    stud.set_contacts(phone: '79998887766', telegram: 'fireman', email: 'frmn@gmail.com')

    assert stud.phone == '79998887766'
    assert stud.telegram == 'fireman'
    assert stud.email == 'frmn@gmail.com'
  end

  def test_student_last_name_and_initials
    assert @student.last_name_and_initials == 'Иванов И. И.'
  end

  def test_student_short_info
    should_be = JSON.generate({
                                last_name_and_initials: @student.last_name_and_initials,
                                contact: {type: :telegram, value: 'ivanushka'},
                                git: 'vanyadev'
                              })

    assert @student.short_info == should_be
  end

  def test_student_from_and_to_hash
    test_hash = {
      last_name: 'Обоев',
      first_name: 'Рулон',
      father_name: 'Поклеевич',
      id: 5,
      phone: '79991112233',
      telegram: 'iloveoboyi',
      email: 'oboi@mail.ru',
      git: 'oboidev'
    }

    stud = Student.from_hash(test_hash)

    assert stud.last_name == 'Обоев'
    assert stud.first_name == 'Рулон'
    assert stud.father_name == 'Поклеевич'
    assert stud.id == 5
    assert stud.phone == '79991112233'
    assert stud.telegram == 'iloveoboyi'
    assert stud.email == 'oboi@mail.ru'
    assert stud.git == 'oboidev'

    assert stud.to_hash == test_hash
  end
end
