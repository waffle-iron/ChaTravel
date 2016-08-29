class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :edit, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @rooms = Room.all
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    @room = Room.find_by(url: params[:url])
    @messages = Message.where(room: @room.id)
    # TODO User情報をキャッシュとかから抜く
    @user = User.find(1)
    @users = User.all
  end

  # GET /rooms/new
  def new
    @room = Room.new
  end

  # GET /rooms/1/edit
  def edit
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = Room.new(room_params)

    respond_to do |format|
      if @room.save
        format.html { redirect_to controller: 'static_pages',action: 'room_page'}
        format.json { render :show, status: :created, location: @room }
      else
        format.html { render :new }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    respond_to do |format|
      if @room.update(room_params)
        format.html { redirect_to @room, notice: 'Room was successfully updated.' }
        format.json { render :show, status: :ok, location: @room }
      else
        format.html { render :edit }
        format.json { render json: @room.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room.destroy
    respond_to do |format|
      format.html { redirect_to rooms_url, notice: 'Room was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def ajax_suggest_request
    p params
    @room = Room.find_by(url: params['room_url'])
    @user = User.find(params['user_id'].to_i)
    url = params['suggest_url']
    result =  scrape(url)
    # TODO DBに入れる
    Suggest.create!({url: params['suggest_url'], ttitle: result[:title], description: result[:description], image: result[:image], room_id: @room.id, user_id: @user.id})
    render json: result.merge({url: url,user_name: @user.name})
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_room
      # @room = Room.find(params[:id])
      @room = Room.find_by(url: params[:url])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def room_params
      params.require(:room).permit(:name, :enable)
    end
end
