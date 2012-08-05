class StoreSectionsController < ApplicationController
  # GET /store_sections
  # GET /store_sections.json
  def index
    @store_sections = StoreSection.order("name").page(params[:page]).per(GroceryListGenerator::Application.config.per_page)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @store_sections }
    end
  end

  # GET /store_sections/1
  # GET /store_sections/1.json
  def show
    @store_section = StoreSection.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store_section }
    end
  end

  # GET /store_sections/new
  # GET /store_sections/new.json
  def new
    @store_section = StoreSection.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_section }
    end
  end

  # GET /store_sections/1/edit
  def edit
    @store_section = StoreSection.find(params[:id])
  end

  # POST /store_sections
  # POST /store_sections.json
  def create
    @store_section = StoreSection.new(params[:store_section])

    respond_to do |format|
      if @store_section.save
        format.html { redirect_to @store_section, notice: 'Store section was successfully created.' }
        format.json { render json: @store_section, status: :created, location: @store_section }
      else
        format.html { render action: "new" }
        format.json { render json: @store_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /store_sections/1
  # PUT /store_sections/1.json
  def update
    @store_section = StoreSection.find(params[:id])

    respond_to do |format|
      if @store_section.update_attributes(params[:store_section])
        format.html { redirect_to @store_section, notice: 'Store section was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @store_section.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_sections/1
  # DELETE /store_sections/1.json
  def destroy
    @store_section = StoreSection.find(params[:id])
    @store_section.destroy

    respond_to do |format|
      format.html { redirect_to store_sections_url }
      format.json { head :no_content }
    end
  end
end
