class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

  def dbdc_client
    unless @dbdc_client
      if ENV['DATABASE_COM_URL']
        @dbdc_client = Databasedotcom::Client.new

        @dbdc_client.debugging = true
        password = @dbdc_client.password
        username = @dbdc_client.username
        stoken = ENV['DATABASE_COM_SECURITY_TOKEN']
        pwd_stoken = "#{password}#{stoken}"
        @dbdc_client.password = pwd_stoken
        puts "Using [#{username}][#{password}] to authenticate"
        @dbdc_client.authenticate
      else
        puts "DATABASE_COM_URL environment variable is not set"
      end
    end

    @dbdc_client
  end

  def dbdc_client=(client)
    @dbdc_client = client
  end

  def sobject_types
    unless @sobject_types
      @sobject_types = dbdc_client.list_sobjects
    end

    @sobject_types
  end

  def const_missing(sym)
    if sobject_types.include?(sym.to_s)
      dbdc_client.materialize(sym.to_s)
    else
      super
    end
  end

end
