require 'tty-prompt'

class Organization

    @name
    @services
    @service_providers

    def initialize(prompt)
        @services = Array.new
        @service_providers = Array.new

        service = Service.new('1', 10, 1)
        @services.push(service)
        service_provider = ServiceProvider.new('1', 1, [service])
        @service_providers.push(service_provider)

        time = Time.new(2019, 1, 1, 13, 30)
        appt = Appointment.new(time, service, 'me', true)
        service_provider.add_appt(appt)

        @name = prompt.ask("Name of the organization: ")
        # @name = name
        puts "\nThe #{@name} organization has been created!\n"

        # list_commands()
    end

    def services
      @services
    end

    def add_service()
        prompt = TTY::Prompt.new
        service_name = prompt.ask("Name of the service: ")

        if(service_already_exists?(service_name))
          puts "Service Already Exists"
          return
        end

        service_price = prompt.ask("Price of the service: ")
        service_duration = prompt.ask("Duration of the service (in hours): ")

        @services.push(Service.new(service_name, service_price, service_duration))
        puts "The #{service_name} service has been created!"
    end

    def remove_service()
        prompt = TTY::Prompt.new

        service_names = []

        @services.each do |service|
          service_names.push(service.name)
        end

        service_to_delete = prompt.select("Choose the service to delete...", service_names)

        @services.each do |existing_service|
          if(existing_service.name == service_to_delete)
            @services.delete(existing_service)
            puts "The #{service_to_delete} service has been deleted"
            return
          end
        end

        puts "The #{@service_to_delete} service does not exist!"
    end

    def list_services()
        if @services.length < 1
            puts "Currently no services are offered"
        else
            puts "The offered services are:\n"
            i = 0
            while i < @services.length
                service_name = @services[i].name
                puts "\t#{service_name}"
                i += 1
            end
        end
    end

    def add_service_provider()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.ask("Name of the service provider: ")

      if(service_provider_already_exists?(service_provider_name))
        puts "Service Provider already exists"
        return
      end

      service_provider_number = prompt.ask("Service provider phone number: ")
      
      service_choices = Array.new

      i = 0
      while i < @services.length
        service_choices.push(@services[i].name)
        i += 1
      end

      available_service_names = prompt.multi_select("Which services can #{service_provider_name} do?:", service_choices)
      available_service_names_array = available_service_names
      available_services = Array.new

      available_service_names_array.each do |service_name|
        if(!service_already_exists?(service_name))
          puts "#{service_name} does not exist"
          return
        end

        @services.each do |service|
          if(service.name == service_name)
            available_services.push(service)
            break
          end
        end
      end

      @service_providers.push(ServiceProvider.new(service_provider_name, service_provider_number, available_services))
      puts "The #{service_provider_name} service provider has been created!"
    end

    def remove_service_provider()
      prompt = TTY::Prompt.new

      providers = []

      @service_providers.each do |provider|
        providers.push(provider.name)
      end
      
      provider_to_delete = prompt.select("Choose which service provider to delete...", providers)

      @service_providers.each do |provider|
        if(provider.name == provider_to_delete)
          @service_providers.delete(provider)
          puts "Service Provider #{provider_to_delete} has been deleted"
          return
        end
      end
      puts "Service provider does not exist"
    end

    def list_service_providers()
      if @service_providers.length < 1
          puts "Currently no service providers"
      else
          puts "The service providers are:\n"
          i = 0
          while i < @service_providers.length
              service_provider_name = @service_providers[i].name
              puts "\t#{service_provider_name}"
              i += 1
          end
      end
    end

    def schedule_appointment()
      prompt = TTY::Prompt.new

      service_provider_name = prompt.ask("Name of the service provider: ")
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Service provider does not exist"
        return
      end

      service_name = prompt.ask("Name of the service: ")
      service = get_service_by_name(service_name)

      if(service == nil)
        puts "Service does not exist"
        return
      end

      if(!service_provider_provides_service?(service_provider_name, service_name))
        puts "#{service_provider_name} does not provide #{service_name}"
        return
      end

      day, month, year = get_date_response()
      start_hour, start_minute = get_time_response()

      if(start_hour == nil || start_minute == nil)
        puts "Invalid Time"
        return
      end

      appointment_time = Time.new(year, month, day, start_hour, start_minute)
      is_recurring = get_recurring_response()
      client = prompt.ask("Client name: ")

      if(service_provider.timeslot_is_available?(appointment_time, service.duration, is_recurring))
        appt = Appointment.new(appointment_time, service, client, is_recurring)
        service_provider.add_appt(appt)
        puts "Appointment added successfully"
      else
        puts "Can't add a new appointment to that time"
      end
    end

    def list_appointments()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.ask("Name of the service provider: ")
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Service provider does not exist"
        return
      end

      service_provider.appointments.each do |appointment|
        appointment.output_appointment
      end
    end

    def view_schedule()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.ask("Name of the service provider: ")
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Service provider does not exist"
        return
      end

      day, month, year = get_date_response()
      time = Time.new(year, month, day)

      service_provider.appointments.each do |appointment|
        if(appointment.is_recurring)
          if(time.wday == appointment.time.wday)
            appointment.output_appointment
          end
        else
          if(is_same_date?(time, appointment.time))
            appointment.output_appointment
          end
        end
      end
    end

    def schedule_availability_block()
      prompt = TTY::Prompt.new
      service_provider_name = prompt.ask("Name of the service provider: ")
      service_provider = get_service_provider_by_name(service_provider_name)

      if(service_provider == nil)
        puts "Service provider does not exist"
        return
      end

      day, month, year = get_date_response()
      start_hour, start_minute = get_time_response()

      if(start_hour == nil || start_minute == nil)
        puts "Invalid Time"
        return
      end

      block_time = Time.new(year, month, day, start_hour, start_minute)
      block_duration = prompt.ask("Duration of the block (in hours): ")
      is_recurring = get_recurring_response()

      new_block = AvailabilityBlock.new(block_time, block_duration, is_recurring)
      service_provider.add_availability_block(new_block)
    end

    def list_commands()
      # puts ("\n")
      # puts (Organization.public_instance_methods - Object.public_instance_methods).sort.join("\n")
      # puts ("\n")

      return (Organization.public_instance_methods - Object.public_instance_methods).sort.join("\n")

    end

    private

    def service_already_exists?(new_service_name)
      @services.each do |existing_service|
        if(existing_service.name == new_service_name)
          return true
        end
      end
      false
    end

    def service_provider_already_exists?(new_service_provider_name)
      @service_providers.each do |existing_service_provider|
        if(existing_service_provider.name == new_service_provider_name)
          return true
        end
      end
      return false
    end

    def service_provider_provides_service?(service_provider_name, service_name)
      @service_providers.each do |service_provider|
        if(service_provider.name == service_provider_name)
          service_provider.services.each do |service|
            if(service.name == service_name)
              return true
            end
          end
          return false
        end
      end
      return false
    end

    def get_service_by_name(service_name)
      @services.each do |service|
        if(service.name == service_name)
          return service
        end
      end
      return nil
    end

    def get_service_provider_by_name(service_provider_name)
      @service_providers.each do |service_provider|
        if(service_provider.name == service_provider_name)
          return service_provider
        end
      end
      return nil
    end

    def get_recurring_response()
      prompt = TTY::Prompt.new
      is_recurring_response = prompt.ask("Appointment recurs weekly? (y/n): ")

      while(is_recurring_response != 'y' && is_recurring_response != 'n')
        puts "Invalid response (must enter 'y' or 'n')"
        is_recurring_response = prompt.ask("Appointment recurs weekly? (y/n): ")
      end

      return is_recurring_response == 'y'
    end

    def get_date_response()
      prompt = TTY::Prompt.new
      month = prompt.ask("Month of appointment: ")
      day = prompt.ask("Date of appointment: ")
      year = prompt.ask("Year of appointment: ")
      return day, month, year
    end

    def get_time_response()
      prompt = TTY::Prompt.new
      time_string = prompt.ask("Time of appointment (ex. '14:45'): ")
      time_string_array = time_string.split(':')

      if(time_string_array.length != 2)
        return nil, nil
      end

      hour = time_string_array[0].to_i
      minute = time_string_array[1].to_i

      if(hour < 0 || hour > 23)
        hour = nil
      end

      if(minute < 0 || minute > 59)
        minute = nil
      end

      return hour, minute
    end

    def is_same_date?(time_1, time_2)
      return (time_1.day == time_2.day && time_1.month == time_2.month && time_1.year == time_2.year)
    end
end
