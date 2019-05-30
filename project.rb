require 'tty-prompt'

class Organization

    @name
    @services
    @service_providers

    def initialize(prompt)
        @services = Array.new
        @sps = Array.new
    
        @name = prompt.ask("Name of the organization: ")
        # @name = name
        puts "\nThe #{@name} organization has been created!\n"

        list_commands()
    end

    def add_service()
        prompt = TTY::Prompt.new
        @service = prompt.ask("Name the service: ")
        @services.push(@service)
        puts "The #{@service} service has been created!"
    end

    def remove_service()
        prompt = TTY::Prompt.new
        @service = prompt.ask("Name of service to delete: ")
        @services.delete(@service)
        puts "The #{@service} service has been removed!"
    end

    def list_services()
        if @services.length < 1
            puts "Currently no services are offered"
        else
            i = 0
            while i < @services.length
                service = @services[i]
                puts "\t#{service}" 
                i += 1
            end
            puts "The offered services are:\n"
        end
    end

    def schedule_appointment(time, service, service_provider, client, isRecurring)
        appt = Appointment.new(time, service, client, isRecurring)
        #do stuff to figure out if this can be scheduled or not
        service_provider.add_appt(appt)
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
end
    

class Appointment
    def initialize(time, service, client, isRecurring)
        @time = time
        @service = service
        @client = client
        @isRecurring = isRecurring
    end

    def get_time
        puts @time
    end
end

class Service
    def initialize(name, price, length)
        @name = name
        @price = price
        @length = length
    end       
end

class ServiceProvider
    def initialize(name, number, services)
        @name = name
        @number = number
        @services = services
        @appointments = []
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
    else
        puts "\nInvalid command!\n"
        org.list_commands()
    end

    response = prompt.ask("Enter a command: ")
end