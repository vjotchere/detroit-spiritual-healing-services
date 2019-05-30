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
      serviceName = prompt.ask("Name of the service: ")

      if(!serviceAlreadyExists?(serviceName))
        puts "Service does not exist"
        return
      end
      day = prompt.ask("Date of appointment: ")
      month = prompt.ask("Month of appointment: ")
      year = prompt.ask("Year of appointment: ")
      time = prompt.ask("Start time of appointment (in 24 hour time): ")
    end

    def schedule_appointment(time, service, service_provider, client, isRecurring)
        appt = Appointment.new(time, service, client, isRecurring)
        #do stuff to figure out if this can be scheduled or not
        if(service_provider.timeslot_is_available(time, service.get_duration(), isRecurring))
          service_provider.add_appt(appt)
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

end


class Appointment
    def initialize(time, service, client, isRecurring)
        @time = time
        @service = service
        @client = client
        @isRecurring = isRecurring
    end

    def get_time
        @time
    end

    def get_service
      @service
    end

    def get_isRecurring
      @isRecurring
    end
end

class Service
    def initialize(name, price, length)
        @name = name
        @price = price
        @length = length
    end

    def get_name()
      @name
    end

    def get_duration()
      @length
    end
end

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
          if(hours_overlap(existingTime, appointment.get_duration, newTime, newDuration))
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
        return !(time1 + time1Duration > time2)
      else
        return !(time2 + time2Duration > time1)
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
end

class DateTime
    def initialize(start_time, recurring)
        @start_time = start_time
        @recurring = recurring
    end
end

prompt = TTY::Prompt.new
org = Organization.new(prompt)
response = prompt.ask("Enter a command (use 'close' to exit): ")
while (response != "close".downcase)
    case response.downcase
    when "add_service"
        org.add_service()
    when "remove_service"
        org.remove_service()
    when "list_services"
        org.list_services()
    when "add_service_provider"
        org.add_service_provider()
    when "remove_service_provider"
        org.remove_service_provider()
    when "list_service_providers"
        org.list_service_providers()
    else
        puts "\nInvalid command!\n"
        org.list_commands()
    end

    response = prompt.ask("Enter a command: ")
end
