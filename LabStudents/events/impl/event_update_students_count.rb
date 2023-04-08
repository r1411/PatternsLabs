# frozen_string_literal: true

class EventUpdateStudentsCount
  def initialize(new_count)
    @new_count = new_count
  end

  attr_reader :new_count
end
