require 'date'

class DurationInWords
  class WordConnector
    def initialize(array)
      @array = array
    end

    def connect_words
      case @array.length
      when 1
        @array.join('')
      when 2
        @array.join(connectors[:two_word_connector])
      else
        last_word = @array.pop
        first_fragment = @array.join(connectors[:word_connector])
        [first_fragment, last_word].join(connectors[:last_word_connector])
      end
    end

    def connectors
      {
        word_connector: ', ',
        two_word_connector: ' and ',
        last_word_connector: ', and '
      }
    end
  end


  def initialize(_begin_time, _end_time)
    @begin_time = _begin_time.strftime('%Q').to_i
    @end_time = _end_time.strftime('%Q').to_i
    @duration_milliseconds = @end_time - @begin_time
  end

  def to_sentence
    WordConnector.new(duration_array).connect_words
  end


  private

  def days
    @days ||= hours / 24
  end

  def hours
    @hours ||= minutes / 60
  end

  def remainder_hours
    @remainder_hours ||= hours % 24
  end

  def minutes
    @minutes ||= seconds / 60
  end

  def remainder_minutes
    @remainder_minutes ||= minutes % 60
  end

  def seconds
    @seconds ||= @duration_milliseconds / 1_000
  end

  def remainder_seconds
    @remainder_secs ||= seconds % 60
  end

  def more_than_one_hour?
    hours > 1
  end

  def more_than_24_hours?
    hours > 24
  end

  def duration_array
    duration_array = [ "#{remainder_minutes} minutes",  "#{remainder_seconds} seconds"]
    if more_than_24_hours?
      remainder_hours = hours % 24
      duration_array.unshift("#{remainder_hours} hours")
      duration_array.unshift("#{days} days")
    else
      duration_array.unshift("#{hours} hours")
    end
    duration_array
  end
end
