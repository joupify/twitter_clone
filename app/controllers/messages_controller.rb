class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.where(parent_id: nil).includes(:replies, :sender)
    # @received_messages = Message.where(receiver: current_user).roots.includes(:sender, :receiver, :replies)
    #   @sent_messages = Message.where(sender: current_user).roots.includes(:sender, :receiver, :replies)
  
  end

  def new
  #   @message = Message.new(receiver_id: params[:receiver_id], parent_id: params[:parent_id])
  #  @receiver = User.find_by(id: params[:receiver_id])
   @message = Message.new(receiver_id: params[:receiver_id])
    @message.parent_id = params[:parent_id] if params[:parent_id].present? # Ajout du parent_id
  end



  def create
  
    @message = Message.new(message_params)
    @receiver = User.find_by(id: @message.receiver_id)
  
    if @receiver.nil?
      redirect_to users_path, alert: 'Destinataire non trouvé.'
      return
    end
  
    if @message.save
      redirect_to messages_path, notice: 'Message envoyé avec succès.'
    else
      flash.now[:alert] = @message.errors.full_messages.join(', ')
      render :new
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id, :parent_id).merge(sender_id: current_user.id)
  end
end