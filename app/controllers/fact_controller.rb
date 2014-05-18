class FactController < ApplicationController
  before_filter :set_fact, only: :destroy

  def create
    @fact = Fact.new.build(fact_params)
    respond_to do |format|
      if @fact.try :save
        format.js { render json: { result: @fact.to_s, status: 'success' } }
      else
        format.js { render json: { status: 'error' } }
      end
    end
  end

  def destroy
    if @fact.destroy
      respond_to do |format|
        format.js { render json: { result: @fact, status: 'success' } }
      end
    end
  end

  private

  def fact_params
    params.permit(:fact)[:fact].gsub(' ', '')
  end

  def set_fact
    @fact = Fact.find(params[:id])
  end
end
