class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :edit, :update, :destroy]
  before_action :verify_create_params, only: [:create]

  # GET /messages
  # GET /messages.json
  def index
    @user = User.find params[:user_id]
    messages_recieved = Message.all.where(recipient_id: @user.id)
    messages_sent = Message.all.where(sender_id: @user.id)
    messages = (messages_recieved.to_a + messages_sent.to_a).sort_by(&:created_at).reverse
    unique_ids = []
    @messages = []
    messages.each do |message|
      next if message.recipient_id.nil? || message.sender_id.nil?

      if message.recipient_id == @user.id
        unique_id = message.sender_id
      else
        unique_id = message.recipient_id
      end
      message.unique_id = unique_id
      unless unique_ids.include? unique_id
        @messages << message
        unique_ids << unique_id
      end
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message.read_at = Time.now
    @message.save
    @message.reload
  end

  def conversation
    @reciever = User.find params[:user_id]
    # TODO: Rename this var names to make sense
    @user = @reciever
    @sender   = User.find params[:sender_id]
    messages_recieved = Message.all.where(recipient_id: @reciever.id, sender_id: @sender.id)
    messages_sent = Message.all.where(recipient_id: @sender.id, sender_id: @reciever.id)
    (messages_recieved + messages_sent).each do |message|
      if message.read_at.nil?
        message.read_at = Time.now
        message.save
      end
    end
    # Refetch the list with new data
    messages_recieved = Message.all.where(recipient_id: @reciever.id, sender_id: @sender.id)
    messages_sent = Message.all.where(recipient_id: @sender.id, sender_id: @reciever.id)
    @messages = messages_recieved.to_a + messages_sent.to_a
    @messages = @messages.sort_by(&:created_at).reverse
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  def verify_create_params
    missing = []
    required = ['recipient_id', 'content']
    required.each do |param|
      missing << param unless params.keys.include? param
    end

    unless missing.empty?
      e = { error: "Missing required fields: #{missing.join(', ')}" }
      render json: e
    end
  end

  # POST /messages
  # POST /messages.json
  def create
    @user = User.find(params[:user_id])
    @message = Message.new(message_params)
    @message.sender_id = @user.id

    respond_to do |format|
      if @message.save
        format.html { redirect_to [@user, @message], notice: 'Message was successfully created.' }
        format.json { render action: 'show', status: :created, location: [@user, @message] }
      else
        format.html { render action: 'new' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end

    recipient = User.find params[:recipient_id]
    if recipient.device_token
      Rails.logger.info "^" * 120
      Rails.logger.info recipient.device_token.inspect
      Rails.logger.info "^" * 120
      begin
        APN_POOL.with do |connection|
          message_content = if @message.content.length > 80
                              @message.content[0...80] + "..."
                            else
                              @message.content
                            end

          notification  = Houston::Notification.new device: recipient.device_token
          notification.alert = "New Message:\n#{message_content}"
          connection.write(notification.message)
        end
      rescue => e
        Rails.logger.info ">" * 120
        Rails.logger.info e.inspect
        Rails.logger.info "<" * 120
      end
    end
  end

  def push_test
    recipient = User.find params[:user_id] || User.find(3)
    content = params[:message] || "Nice Foo!"
    Rails.logger.info "*" * 88
    Rails.logger.info "APN_POOL"
    Rails.logger.info APN_POOL.inspect
    Rails.logger.info "---"
    Rails.logger.info "if recipient.device_token"
    Rails.logger.info  recipient.device_token.inspect
    APN_POOL.with do |connection|
      message_content = if content.length > 80
                          content[0...80] + "..."
                        else
                          content
                        end
      Rails.logger.info "---"
      Rails.logger.info "message_content"
      Rails.logger.info message_content.inspect

      notification  = Houston::Notification.new device: recipient.device_token
      notification.alert = "New Message:\n#{message_content}"

      Rails.logger.info "---"
      Rails.logger.info "notification"
      Rails.logger.info notification.inspect
      Rails.logger.info "---"
      Rails.logger.info "notification.message"
      Rails.logger.info notification.message.inspect
      connection.write(notification.message)
      Rails.logger.info "---"
      Rails.logger.info "connection"
      Rails.logger.info connection.inspect
    end
    Rails.logger.info "*" * 88
    render text: "DONE"
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render action: 'show', status: :ok, location: @message }
      else
        format.html { render action: 'edit' }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.permit('recipient_id', 'content')
    end
end
