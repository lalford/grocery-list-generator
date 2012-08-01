class GroceryListsController < ApplicationController
  before_filter :handle_fractional_quantities, :only => [:create, :update]

  # GET /grocery_lists
  # GET /grocery_lists.json
  def index
    @grocery_lists = GroceryList.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @grocery_lists }
    end
  end

  # GET /grocery_lists/1
  # GET /grocery_lists/1.json
  def show
    @grocery_list = GroceryList.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @grocery_list }
    end
  end

  # GET /grocery_lists/1/generate
  def generate
    @grocery_list = GroceryList.find(params[:id])
    @generated_list = @grocery_list.generate

    respond_to do |format|
      format.html { render action: "generated_list" }
      format.json { head :no_content }
    end
  end

  # GET /grocery_lists/new
  # GET /grocery_lists/new.json
  def new
    @grocery_list = GroceryList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @grocery_list }
    end
  end

  # GET /grocery_lists/1/edit
  def edit
    @grocery_list = GroceryList.find(params[:id])
  end

  # POST /grocery_lists
  # POST /grocery_lists.json
  def create
    @grocery_list = GroceryList.new(params[:grocery_list])
    to_email = params[:grocery_list][:to_email]
    puts "to email: #{to_email}"

    respond_to do |format|
      if params[:commit] == GENERATE_LIST
        @generated_list = @grocery_list.generate
        GroceryListMailer.generated_list_email(@grocery_list.name, @generated_list, to_email).deliver unless to_email.nil? or to_email.blank?
        format.html { render action: "generated_list" }
        format.json { head :no_content }
      else
        # normal create action
        if @grocery_list.save
          format.html { redirect_to @grocery_list, notice: 'Grocery list was successfully created.' }
          format.json { render json: @grocery_list, status: :created, location: @grocery_list }
        else
          format.html { render action: "new" }
          format.json { render json: @grocery_list.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PUT /grocery_lists/1
  # PUT /grocery_lists/1.json
  def update
    @grocery_list = GroceryList.find(params[:id])
    to_email = params[:grocery_list][:to_email]
    puts "to email: #{to_email}"

    respond_to do |format|
      if @grocery_list.update_attributes(params[:grocery_list])
        if params[:commit] == GENERATE_LIST
          @generated_list = @grocery_list.generate
          GroceryListMailer.generated_list_email(@grocery_list.name, @generated_list, to_email).deliver unless to_email.nil? or to_email.blank?
          format.html { render action: "generated_list" }
          format.json { head :no_content }
        else
          format.html { redirect_to @grocery_list, notice: 'Grocery list was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @grocery_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grocery_lists/1
  # DELETE /grocery_lists/1.json
  def destroy
    @grocery_list = GroceryList.find(params[:id])
    @grocery_list.destroy

    respond_to do |format|
      format.html { redirect_to grocery_lists_url }
      format.json { head :no_content }
    end
  end

  def handle_fractional_quantities
    compute_fractional_quantities params[:grocery_list][:grocery_list_foods_attributes] unless params[:grocery_list][:grocery_list_foods_attributes].nil?
  end
end
