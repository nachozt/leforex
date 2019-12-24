class CompareController < ApplicationController
  # GET /institutions
  # GET /institutions.json
  def index
  end

  def today
    @institutions = Institution.all
    # TODO: receive "from" and "to" from params
    @conversion_input = { from: "USD", to: "CLP", quantity: params[:quantity] }
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def today_params
      params.require(:today).permit(:quantity)
    end
end
