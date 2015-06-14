class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    # render json: @user.friends
    if(params[:current_user])
      if(params[:current_user].to_i != @user.id)
        cuser = User.find(params[:current_user])
        render :json => @user.as_json.merge(:mutual_friends => @user.friends_all.select { |u| cuser.friends_all.include? u})
      else
        @user
      end
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.find_by_email params[:email]
    unless @user.nil?
      params[:id] = @user.id
      update
      return nil
    end

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render action: 'show', status: :created, location: @user }
        WelcomeMailer.send_welcome_message(@user.email).deliver rescue nil
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    @user.fetch_friends
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @user }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

    @user.fetch_friends
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  def reload_friends_list
    User.all.each do |user|
      user.fetch_friends
    end
    redirect_to root_url, notice: "Friends List Fetch Complete"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.permit(:fb_oauth_token, :fb_refresh_token, :fb_user_id, :email,
                    :gender, :birthday, :time, :city, :country, :avatar_url,
                    :meta, :recieve_emails, :first_name, :last_name,
                    :device_token)
    end
end
