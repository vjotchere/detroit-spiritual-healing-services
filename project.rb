require 'tty-prompt'

prompt = TTY::Prompt.new

# date                  = prompt.ask('Date:')
# start_time            = prompt.ask('Start time:')
# service_provider_name = prompt.ask('Service provider name:')

class Organization

    @name
    @services
    @service_providers

    def initialize(name)
        @services = Array.new
        @sps = Array.new
    
        # @name = prompt.ask("Name of the organization: ")
        @name = name
        puts "The #{name} organization has been created!"

        puts "Welcome! Use the following commands:\n\n"
        puts (Organization.public_instance_methods - Object.public_instance_methods).sort.join("\n")
        puts ("\n")
    end

    def add_service(service)
        # @service = prompt.ask("Name of the service: ")
        @services.push(service)
    end

    def list_services()
        puts "The offered services are:\n"
        i = 0
        while i < @services.length
            service = @services[i]
            puts "\t#{service}" 
            i += 1
        end
    end

    def remove_service(service)
        # @service = prompt.ask("Name of service to delete: ")
        @services.delete(service)
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

# org = Organization.new(['massage', 'hotstone'])
# tati = ServiceProvider.new('tati',1,['massage'])
# org.schedule_appointment(1,'massage', tati,'client',true)
# puts tati.print_appts