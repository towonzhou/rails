class ExercisesController < ApplicationController
  # GET /exercises
  # GET /exercises.json
  def index
    @exercises = Exercise.all
    @exercise = Exercise.new()

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @exercises }
    end
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/new
  # GET /exercises/new.json
  def new
    @exercise = Exercise.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @exercise }
    end
  end

  # GET /exercises/1/edit
  def edit
    @exercise = Exercise.find(params[:id])
  end


  # POST /exercises
  # POST /exercises.json
  def create
    @exercise = Exercise.new()
    
    render run_code(params[:exercise][:code])

=begin
    respond_to do |format|
      if @exercise.save
        format.html { redirect_to @exercise, notice: 'Exercise was successfully created.' }
        format.json { render json: @exercise, status: :created, location: @exercise }
      else
        format.html { render action: "new" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PUT /exercises/1
  # PUT /exercises/1.json
  def update
    @exercise = Exercise.find(params[:id])

    respond_to do |format|
      if @exercise.update_attributes(params[:exercise])
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise = Exercise.find(params[:id])
    @exercise.destroy

    respond_to do |format|
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
    end
  end

  private
  def save_file(file) code
    @filename = file.original_filename
    File.open("#{Dir::pwd}/public/#{@filename}", 'wb') do |f|
      f.write(file.read)
    end
    return @filename
  end

  def run_code code
    eval(code.read)
    file_out = File.open("public/0.out", 'r')
    file_answer = File.open("public/0.answer", 'r')
    if (file_out.read + "\n") == file_answer.read
      "ok"
    else
      "wrong"
    end
  end

end
