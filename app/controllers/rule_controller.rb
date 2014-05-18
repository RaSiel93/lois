class RuleController < ApplicationController
  before_filter :set_rule, only: :destroy

  def create
    @rule = Rule.new.build(rule_params)
    respond_to do |format|
      if @rule.try :save
        format.js { render json: { result: @rule.to_s, status: 'success' } }
      else
        format.js { render json: { status: 'fail' } }
      end
    end
  end

  def destroy
    if @rule.destroy
      respond_to do |format|
        format.js { render json: { result: @rule, status: 'success' } }
      end
    end
  end

  private

  def rule_params
    params.permit(:rule)[:rule].gsub(' ', '')
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end
end
