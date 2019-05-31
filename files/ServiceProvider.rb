class ServiceProvider
    def initialize(name, number, services)
        @name = name
        @number = number
        @services = services
        @appointments = []
    end

    def timeslot_is_available?(newTime, newDuration, isRecurring)
      @appointments.each do |appointment|
        existingTime = appointment.get_time
        if(existingTime.wday == newTime.wday)
          if(hours_overlap?(existingTime, appointment.get_service.get_duration(), newTime, newDuration))
            if(is_same_date(existingTime, newTime))
              return false
            else
              if(appointment.get_isRecurring && isRecurring)
                return false
              elsif(newTime < existingTime && isRecurring)
                return false
              elsif(existingTime < newTime && appointment.get_isRecurring)
                return false
              end
            end
          end
        end
      end
      return true
    end

    def get_name
      @name
    end

    def hours_overlap?(time1, time1Duration, time2, time2Duration)
      if(time1 < time2)
        return !(time1 + time1Duration.to_i > time2)
      else
        return !(time2 + time2Duration.to_i > time1)
      end
    end

    def is_same_date?(time1, time2)
      return (time1.day == time2.day && time1.month == time2.month && time1.year == time2.year)
    end

    def add_service(service)
        services.push(service)
    end

    def add_appt(appt)
        @appointments.push(appt)
    end

    def print_appts
        puts @appointments[0].get_time
    end

    def get_services
      @services
    end
end