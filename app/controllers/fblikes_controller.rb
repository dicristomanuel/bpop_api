class FblikesController < ApplicationController
  before_action :set_fblike, only: [:show, :update, :destroy]

  # GET /fblikes
  # GET /fblikes.json
  def index
    @fblikes = Fblike.all

    render json: @fblikes
  end

  # GET /fblikes/1
  # GET /fblikes/1.json
  def show
    render json: @fblike
  end

  # POST /fblikes
  # POST /fblikes.json
  def create
    @fblike = Fblike.new(fblike_params)

    if @fblike.save
      render json: @fblike, status: :created, location: @fblike
    else
      render json: @fblike.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /fblikes/1
  # PATCH/PUT /fblikes/1.json
  def update
    @fblike = Fblike.find(params[:id])

    if @fblike.update(fblike_params)
      head :no_content
    else
      render json: @fblike.errors, status: :unprocessable_entity
    end
  end

  # DELETE /fblikes/1
  # DELETE /fblikes/1.json
  def destroy
    @fblike.destroy

    head :no_content
  end

  private

    def set_fblike
      @fblike = Fblike.find(params[:id])
    end

    def fblike_params
      params.require(:fblike).permit(:user_name)
    end
end
