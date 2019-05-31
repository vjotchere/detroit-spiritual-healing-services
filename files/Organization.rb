require 'tty-prompt'

class Organization

    @name
    @services
    @service_providers

    def initialize(prompt)
        @services = Array.new
        @service_providers = Array.new

        @name = prompt.ask("Name of the organization: ")
        # @name = name
        puts "\nThe #{@name} organization has been created!\n"

        list_commands()
    end

    def add_service()
        prompt = TTY::Prompt.new
        serviceName = prompt.ask("Name of the service: ")

        if(serviceAlreadyExists?(serviceName))
          puts "Service Already Exists"
          return
        end

        servicePrice = prompt.ask("Price of the service: ")
        serviceDuration = prompt.ask("Duration of the service: ")

        @services.push(Service.new(serviceName, servicePrice, serviceDuration))
        puts "The #{serviceName} service has been created!"
    end

    def remove_service()
        prompt = TTY::Prompt.new
        serviceToDeleteName = prompt.ask("Name of service to delete: ")

        @services.each do |existingService|
          if(existingService.get_name() == serviceToDeleteName)
            @services.delete(existingService)
            puts "The #{serviceToDeleteName} service has been deleted"
            return
          end
        end

        puts "The #{@serviceToDeleteName} service does not exist!"
    end

    def list_services()
        if @services.length < 1
            puts "Currently no services are offered"
        else
            puts "The offered services are:\n"
            i = 0
            while i < @services.length
                serviceName = @services[i].get_name
                puts "\t#{serviceName}"
                i += 1
            end
        end
    end

    def add_service_provider()
      prompt = TTY::Prompt.new
      serviceProviderName = prompt.ask("Name of the service provider: ")

      if(serviceProviderAlreadyExists?(serviceProviderName))
        puts "Service Provider already exists"
        return
      end

      serviceProviderNumber = prompt.ask("Service provider phone number: ")
      availableServiceNamesString = prompt.ask("List of available services (separated by ','): ")
      availableServiceNamesArray = availableServiceNamesString.split(', ')
      availableServices = Array.new

      availableServiceNamesArray.each do |serviceName|
        if(!serviceAlreadyExists?(serviceName))
          puts "#{serviceName} does not exist"
          return
        end

        @services.each do |service|
          if(service.get_name == serviceName)
            availableServices.push(service)
            break
          end
        end
      end

      @service_providers.push(ServiceProvider.new(serviceProviderName, serviceProviderNumber, availableServices))
      puts "The #{serviceProviderName} service provider has been created!"
    end

    def remove_service_provider()
      prompt = TTY::Prompt.new
      serviceProviderName = prompt.ask("Name of the service provider to delete: ")
      @service_providers.each do |provider|
        if(provider.get_name == serviceProviderName)
          @service_providers.delete(provider)
          puts "Service Provider #{serviceProviderName} has been deleted"
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
              serviceProviderName = @service_providers[i].get_name
              puts "\t#{serviceProviderName}"
              i += 1
          end
      end
    end

    def schedule_appointment()
      prompt = TTY::Prompt.new

      serviceProviderName = prompt.ask("Name of the service provider: ")
      serviceProvider = getServiceProviderByName(serviceProviderName)

      if(serviceProvider == nil)
        puts "Service provider does not exist"
        return
      end

      serviceName = prompt.ask("Name of the service: ")
      service = getServiceByName(serviceName)

      if(service == nil)
        puts "Service does not exist"
        return
      end

      if(!serviceProviderProvidesService?(serviceProviderName, serviceName))
        puts "#{serviceProviderName} does not provide #{serviceName}"
        return
      end

      day = prompt.ask("Date of appointment: ")
      month = prompt.ask("Month of appointment: ")
      year = prompt.ask("Year of appointment: ")
      startHour, startMinute = getTimeResponse()

      if(startHour == nil || startMinute == nil)
        puts "Invalid Time"
        return
      end

      appointmentTime = Time.new(year, month, day, startHour, startMinute)
      isRecurring = getRecurringResponse()
      client = prompt.ask("Client name: ")

      if(serviceProvider.timeslot_is_available?(appointmentTime, service.get_duration(), isRecurring))
        appt = Appointment.new(appointmentTime, service, client, isRecurring)
        serviceProvider.add_appt(appt)
        puts "appointment added successfully"
      else
        puts "cant add to that time"
      end
    end

    def view_schedule(service_provider, day)
        hits = []
        #for appt in service_provider.appointments do
            #if that appt is on the given day
                #hits.push(appt)
        #calculate_available_times(hits)
        # puts all appointments
        # puts all the available times
    end

    private

    def list_commands()
        puts ("\n")
        puts (Organization.public_instance_methods - Object.public_instance_methods).sort.join("\n")
        puts ("\n")
    end

    def serviceAlreadyExists?(newServiceName)
      @services.each do |existingService|
        if(existingService.get_name() == newServiceName)
          return true
        end
      end
      false
    end

    def serviceProviderAlreadyExists?(newServiceProviderName)
      @service_providers.each do |existingServiceProvider|
        if(existingServiceProvider.get_name == newServiceProviderName)
          return true
        end
      end
      return false
    end

    def serviceProviderProvidesService?(serviceProviderName, serviceName)
      @service_providers.each do |serviceProvider|
        if(serviceProvider.get_name == serviceProviderName)
          serviceProvider.get_services.each do |service|
            if(service.get_name == serviceName)
              return true
            end
          end
          return false
        end
      end
      return false
    end

    def getServiceByName(serviceName)
      @services.each do |service|
        if(service.get_name == serviceName)
          return service
        end
      end
      return nil
    end

    def getServiceProviderByName(serviceProviderName)
      @service_providers.each do |serviceProvider|
        if(serviceProvider.get_name == serviceProviderName)
          return serviceProvider
        end
      end
      return nil
    end

    def getRecurringResponse()
      prompt = TTY::Prompt.new
      isRecurringResponse = prompt.ask("Appointment recurs weekly? (y/n): ")

      while(isRecurringResponse != 'y' && isRecurringResponse != 'n')
        puts "Invalid response (must enter 'y' or 'n')"
        isRecurringResponse = prompt.ask("Appointment recurs weekly? (y/n): ")
      end

      return isRecurringResponse == 'y'
    end

    def getTimeResponse()
      prompt = TTY::Prompt.new
      timeString = prompt.ask("Time of appointment (ex. '14:45'): ")
      timeStringArray = timeString.split(':')

      if(timeStringArray.length != 2)
        return nil, nil
      end

      hour = timeStringArray[0].to_i
      minute = timeStringArray[1].to_i

      if(hour < 0 || hour > 23)
        hour = nil
      end

      if(minute < 0 || minute > 59)
        minute = nil
      end

      return hour, minute
    end
end

