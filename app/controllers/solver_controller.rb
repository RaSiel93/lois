class SolverController < ApplicationController
  def index
    @rules = Rule.all
  end

  def solve
    respond_to do |format|
      if check_condition( condition_params[:condition] )
        format.js { render json: { result: params[:condition], status: 'success' } }
      else
        format.js { render json: { status: 'error' } }
      end
    end
  end

  private

  def check_condition condition
    condition[/\(.*\)$/]
  end

  def condition_params
    params.permit(:condition)
  end
end
