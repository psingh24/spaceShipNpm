#!/usr/bin/env ruby
require "Spaceship"

username = ARGV[0]

password = ARGV[1]

company_name = ARGV[2]

app_name = ARGV[3]

emailRegex = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
bundleID = ''

if (username.match(emailRegex))
    begin
        Spaceship::Portal.login(username, password)

        begin 
            bundleID = "com.#{company_name}.#{app_name}"
            
            puts "Your bundle id: #{bundleID}"

            app = Spaceship::Portal.app.create!(bundle_id: bundleID, name: app_name)
        rescue Spaceship::UnexpectedResponse => e
            puts "The app name has already been taken, please try again."
        end

    rescue Spaceship::InvalidUserCredentialsError => e
        puts "#{e} Please try again."
    rescue RuntimeError => e
        puts "Please check your email address and password. #{e}"
    end

    
    if app
    
        # Create a new certificate signing request
        csr, pkey = Spaceship::Portal.certificate.create_certificate_signing_request
    
        # Use the signing request to create a new push certificate 
        Spaceship::Portal.certificate.production_push.create!(csr: csr, bundle_id: bundleID)
       
        cert = Spaceship::Portal.certificate.production.all.first
    
        profile = Spaceship::Portal.provisioning_profile.ad_hoc.create!(bundle_id: bundleID,
                                                                        certificate: cert,
                                                                        name: app_name)
    else
        puts "Somthing went wrong, app was not created"
    end
else 
    puts "Invalid email address, Please try again."
end