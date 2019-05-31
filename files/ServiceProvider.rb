class ServiceProvider
    attr_reader :name, :number, :services, :appointments

    def initialize(name, number, services)
        @name = name
        @number = number
        @services = services
        @appointments = []
    end

    def timeslot_is_available?(new_time, new_duration, is_recurring)
      @appointments.each do |appointment|
        if(appointment.time.wday == new_time.wday)
          if(hours_overlap?(appointment.time, appointment.service.duration(), new_time, new_duration))
            if(is_same_date?(appointment.time, new_time))
              return false
            else
              if(appointment.is_recurring && is_recurring)
                return false
              elsif(new_time <= appointment.time && is_recurring)
                return false
              elsif(appointment.time <= new_time && appointment.is_recurring)
                return false
              end
            end
          end
        end
      end
      return true
    end

    def hours_overlap?(time_1, time_1_duration, time_2, time_2_duration)
      #Check which time starts first. Then add the duration to the earlier start time
      #to see if it overlaps with the later start time.
      time_1_string = time_1.strftime('%R')
      time_2_string = time_2.strftime('%R')
      if(time_1_string < time_2_string)
        return (time_1 + (time_1_duration.to_i*60*60)).strftime('%R')  > time_2_string
      else
        return (time_2 + (time_2_duration.to_i*60*60)).strftime('%R')  > time_1_string
      end
    end

    #returns true if time_1 comes before time_2
    def time_comparison(time_1, time_2)
    end

    def self.is_same_date?(time_1, time_2)
      return (time_1.day == time_2.day && time_1.month == time_2.month && time_1.year == time_2.year)
    end

    def add_service(service)
        services.push(service)
    end

    def add_appt(appt)
        @appointments.push(appt)
    end
end
