class SobjectsController < ApplicationController
  include Databasedotcom::Rails::Controller
  # GET /sobjects
  # GET /sobjects.json
  def index
    # Commented out following list of sobjects for performance reasons.
    # Hardcoding SObject list to improve performance
    #sobject_names = dbdc_client.list_sobjects
    #dbdc_client.debugging = true

    sobject_names = ['Profile', 'UserLicense', 'User', 'Organization', 'Group']
    @sobjects = []

    sobject_names.each do |name|
      begin
        klass = dbdc_client.materialize(name)
        @sobjects << {:name => name, :count => klass.count}
      rescue Databasedotcom::SalesForceError => e
        logger.warn (e)
      end
    end

    @sobjects = @sobjects.sort {|x, y| y[:count] <=> x[:count]}

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @sobjects }
    end
  end

  # GET /sobjects/1
  # GET /sobjects/1.json
  def show
    @class_name = params[:id]
    @klass = dbdc_client.materialize(@class_name)
    @records = @klass.all

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @records }
    end
  end

  # GET /sobjects/new
  # GET /sobjects/new.json
  def new
    @sobject = Sobject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @sobject }
    end
  end

  # GET /sobjects/1/edit
  def edit
    @sobject = Sobject.find(params[:id])
  end

  # POST /sobjects
  # POST /sobjects.json
  def create
    @sobject = Sobject.new(params[:sobject])

    respond_to do |format|
      if @sobject.save
        format.html { redirect_to @sobject, notice: 'Sobject was successfully created.' }
        format.json { render json: @sobject, status: :created, location: @sobject }
      else
        format.html { render action: "new" }
        format.json { render json: @sobject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /sobjects/1
  # PUT /sobjects/1.json
  def update
    @sobject = Sobject.find(params[:id])

    respond_to do |format|
      if @sobject.update_attributes(params[:sobject])
        format.html { redirect_to @sobject, notice: 'Sobject was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @sobject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sobjects/1
  # DELETE /sobjects/1.json
  def destroy
    @sobject = Sobject.find(params[:id])
    @sobject.destroy

    respond_to do |format|
      format.html { redirect_to sobjects_url }
      format.json { head :ok }
    end
  end
end
