class ActivityInstance
  include ActiveModel::AttributeMethods
  
  attr_accessor :title, :start, :end, :allDay, :event_id
  
  def self.occurrences_between(begin_date,end_date)
    # Using Squeel
    # line 1 = Event doesn't repeat, but ends in window
    # line 2 = Event doesn't repeat, but starts in window
    # line 2 = Event doesn't repeat, but starts before and ends after
    # line 4 = Event starts before our end date and repeats until a certain point of time, and that point of time after our begin date
    # line 5 = Event repeats indefinitely, then all we care about is that it has started at somepoint in the last
    results = Activity.where{
      ( 
        (repeats == 'no') & 
        (from_date >= begin_date) & 
        (from_date <= end_date)
      ) | ( 
        (repeats == 'no') & 
        (to_date >= begin_date) & 
        (to_date <= end_date)
      ) | ( 
        (repeats == 'no') & 
        (from_date <= begin_date) & 
        (to_date >= end_date)
      ) | ( 
        (repeats != 'no') & 
        (from_date <= end_date) & 
        (repeat_ends == 'yes') & 
        (repeat_ends_on >= begin_date)
      ) | ( 
        (repeats != 'no') & 
        (repeat_ends == 'no') & 
        (from_date <= end_date)
      )  
    }
    results.map { |activity| 
      activity.schedule.occurrences_between(begin_date,end_date).map { |date|
        i = ActivityInstance.new()
        i.title = activy.name
        i.start = date
        i.end = date + activity.duration
        i.allDay = activity.is_all_day
        i.event_id = activity.id
        i
      }
    }.flatten.sort! {|x,y| x.start <=> y.start }
  end
  
end