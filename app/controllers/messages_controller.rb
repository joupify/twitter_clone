class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @received_messages = current_user.received_messages
    @sent_messages = current_user.sent_messages
  end

  def new
    @message = current_user.sent_messages.build
    @receiver = User.find_by(id: params[:receiver_id])

    if @receiver.nil?
      redirect_to users_path, alert: 'Receiver not found.'
    end
  end

  def create
    @message = current_user.sent_messages.build(message_params)
    @receiver = User.find_by(id: params[:message][:receiver_id])
  
    if @receiver.nil?
      redirect_to users_path, alert: 'Destinataire non trouvé.'
      return
    end
  
    @message.receiver = @receiver
    @message.parent_id = params[:message][:parent_id] if params[:message][:parent_id].present?

  
    if @message.save
      redirect_to messages_path, notice: 'Message envoyé avec succès.'
    else
      flash.now[:alert] = @message.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end
end