class MessagesController < ApplicationController
  api :GET, "/users/:user_id/messages", "Get a list of user messages"
    description "Get a list of all messages to or from a user."
    error code: :unauthorized, desc: " - Bad Token"
    header "Authorization", "Token token=[access_token]", required: true
  def index
    @recieved_messages = Message.where( recipient: User.find( params[:user_id] ) )
    @sent_messages     = Message.where( sender: User.find( params[:user_id] ) )
    @messages          = Message.where( id: @sent_messages + @recieved_messages )

    if @messages.any?
      authorize @messages
    else
      skip_authorization
    end

    render json: @messages, status: :ok
  end

  api :POST, "/messages", "Create a new message."
    description "Create a new message."
    error code: :unprocessable_entity, desc: " - Bad parameters for User"
    error code: :unauthorized, desc: " - Bad Token"
    param :recipient_id, String, desc: "user id to send the message to", required: true
    param :subject,      String, desc: "message subject",                required: true
    param :body,         String, desc: "message body",                   required: true
    header "Authorization", "Token token=[access_token]", required: true
  def create
    @message = current_user.sent_messages.new( create_params )
    authorize @message

    if @message.save
      render json: @message, status: :created
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  private
    def create_params
      params.permit( :recipient_id, :subject, :body )
    end
end
