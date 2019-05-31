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
        existing_time = appointment.time
        if(existing_time.wday == new_time.wday)
          if(hours_overlap?(existing_time, appointment.service.duration(), new_time, new_duration))
            if(is_same_date(existing_time, new_time))
              return false
            else
              if(appointment.is_recurring && is_recurring)
                return false
              elsif(new_time < existing_time && is_recurring)
                return false
              elsif(existing_time < new_time && appointment.is_recurring)
                return false
              end
            end
          end
        end
      end
      return true
    end

    def hours_overlap?(time_1, time_1_duration, time_2, time_2_duration)
      if(time_1 < time_2)
        return !(time_1 + time_1_duration.to_i > time_2)
      else
        return !(time_2 + time_2_duration.to_i > time_1)
      end
    end

    def is_same_date?(time_1, time_2)
      return (time_1.day == time_2.day && time_1.month == time_2.month && time_1.year == time_2.year)
    end

    def add_service(service)
        services.push(service)
    end

    def add_appt(appt)
        @appointments.push(appt)
    end
end
