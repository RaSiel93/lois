class SolverController < ApplicationController
  def index
    @rules = Rule.all
    @facts = Fact.all
  end

  def solve
    purpose = Purpose.new
    respond_to do |format|
      if purpose.build(purpose_params.gsub(' ', ''))
        format.js { render json: { result: purpose.print( purpose.decide ), status: 'success' } }
      else
        format.js { render json: { status: 'error' } }
      end
    end
  end

  private

  def purpose_params
    params[:purpose]
  end
end
