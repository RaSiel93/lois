class SolverController < ApplicationController
  def index
    
  end

  def solve
    result = 'RASIEL'
    respond_to do |format|
      format.js { render json: { result: result, status: 'success' } }
    end
  end
end
