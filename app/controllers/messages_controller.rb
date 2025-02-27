class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @received_messages = current_user.received_messages
    @sent_messages = current_user.sent_messages
    @messages = Message.includes(:sender) # Inclut les expéditeurs des messages et des réponses
    .for_user(current_user)
                 .where(parent_id: nil)
                 .order(created_at: :desc)

  end
  
  

  def new
  
   @message = Message.new(receiver_id: params[:receiver_id])
    @message.parent_id = params[:parent_id] if params[:parent_id].present? # Ajout du parent_id
     @parent_message = Message.find_by(id: params[:parent_id]) # Récupère le message parent
  @receiver = @parent_message.sender # Le destinataire de la réponse est l'expéditeur du message parent
  end



  def create
  
    @message = Message.new(message_params)
    @receiver = User.find_by(id: @message.receiver_id)
    @parent_message = Message.find_by(id: @message.parent_id)
  @message.receiver = @parent_message.sender # Le destinataire de la réponse est l'expéditeur du message parent
  
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