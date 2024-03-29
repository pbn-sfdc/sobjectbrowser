class RecordsController < ApplicationController

  # GET /records
  # GET /records.json
  def index
    @class_name = params[:sobject_id]
    @klass = dbdc_client.materialize(@class_name)
    @records = @klass.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @records }
    end
  end

  # GET /records/1
  # GET /records/1.json
  def show
    sobject_name = params[:sobject_id]
    record_id = params[:id]

    @record = dbdc_client.find(sobject_name, record_id);

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/new
  # GET /records/new.json
  def new
    @class_name = params[:sobject_id]
    @klass = dbdc_client.materialize(@class_name)
    @record = @klass.new
    set_updateable_attributes()

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @record }
    end
  end

  # GET /records/1/edit
  def edit
    @record = Record.find(params[:id])
  end

  # POST /records
  # POST /records.json
  def create
    @class_name = params[:sobject_id]
    @klass = dbdc_client.materialize(@class_name)

    @record = @klass.new(@klass.coerce_params(params[:record]))
    if @record.respond_to?(:OwnerId)
      @record['OwnerId'] = dbdc_client.user_id
    end
#    @record['IsConverted'] = false
#    @record['IsUnreadByOwner'] = false

    respond_to do |format|
      begin
        if @record.save
          format.html { redirect_to sobject_records_path(@class_name), notice: 'Record was successfully created.' }
          format.json { render json: @record, status: :created, location: @record }
        else
          set_updateable_attributes()
          format.html { render action: "new" }
          format.json { render json: @record.errors, status: :unprocessable_entity }
        end
      rescue Databasedotcom::SalesForceError => e
        set_updateable_attributes()
        @errors = []
        @errors << e
        format.html { render :partial => 'error' }
        format.json { render json: @errors, status: :unprocessable_entity }
      end

    end
  end

  # PUT /records/1
  # PUT /records/1.json
  def update
    @record = Record.find(params[:id])

    respond_to do |format|
      if @record.update_attributes(params[:record])
        format.html { redirect_to @record, notice: 'Record was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /records/1
  # DELETE /records/1.json
  def destroy
    @record = Record.find(params[:id])
    @record.destroy

    respond_to do |format|
      format.html { redirect_to records_url }
      format.json { head :ok }
    end
  end

  protected

  def set_updateable_attributes
    @updateable_attributes = []
    @record.attributes.each do |a|
      if @klass.updateable?(a[0])
        @updateable_attributes << a[0]
      end
    end
  end
end
