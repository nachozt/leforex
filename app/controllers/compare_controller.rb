class CompareController < ApplicationController
  # GET /institutions
  # GET /institutions.json
  def index
  end

  def today
    # TODO: add exchange data
    @institutions = Institution.all
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def today_params
      params.require(:today).permit(:quantity)
    end
end
