class SolverController < ApplicationController
  def index
    @rules = Rule.all
    @facts = Fact.all
  end

  def solve
    respond_to do |format|
      if purpose = Purpose.new(purpose_params)
        solutions = purpose.decide
        format.js { render json: { result: solutions, status: 'success' } }
      else
        format.js { render json: { status: 'error' } }
      end
    end
  end

  private

  def purpose_params
    params[:purpose].gsub(' ', '')
  end
end
