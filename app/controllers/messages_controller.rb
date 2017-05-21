class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy, :reply]

  # GET /messages
  # GET /messages.json
  def index
    @messages = Message.all
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    email = Gmailer.gmail.inbox.find(:all).find {|e| e.msg_id == @message.message_id.to_i } #convert due to wrong type
    @attachments = email ? email.message.attachments : []
  end

  # PATCH/PUT /messages/1
  # PATCH/PUT /messages/1.json
  def update
    respond_to do |format|
      if @message.update(message_params)
        format.html { redirect_to @message, notice: 'Message was successfully updated.' }
        format.json { render :show, status: :ok, location: @message }
      else
        format.html { redirect :back }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message.destroy
    respond_to do |format|
      format.html { redirect_to messages_url, notice: 'Message was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reply
    message = @message
    message_body = params[:message][:body]
    email = Gmailer.gmail.compose do
      to message.from[2..-3]
      subject message.subject
      text_part do
        body message_body
      end
    end
    email.deliver!

    #do nothing for now
    redirect_to @message, notice: 'Reply sent.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def message_params
      params.require(:message).permit(:read, :star)
    end
end
