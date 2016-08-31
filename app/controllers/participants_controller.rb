class ParticipantsController < ApplicationController

	def index
		@total_participants = Participant.all
	end

	def search
		@participants = Participant.search(params[:uuid])
		if @participants
			respond_to do |format|
				format.html { render partial: 'search' }
			end
		end
	end


end
