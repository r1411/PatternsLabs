# frozen_string_literal: true

class EventManager
  private_class_method :new

  @observers = Hash.new { |this_hash, key| this_hash[key] = [] }

  def self.subscribe(observer, event_type)
    return if @observers[event_type].include?(observer)

    @observers[event_type] << observer
  end

  def self.unsubscribe(observer, event_type)
    @observers[event_type].delete(observer)
  end

  def self.notify(event)
    event_type = event.class
    @observers[event_type].each { |observer| observer.on_event(event) }
  end
end
