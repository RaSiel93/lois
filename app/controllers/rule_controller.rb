class RuleController < ApplicationController
  before_filter :set_rule, only: :destroy

  def create
    @rule = Rule.new(rule_params)
    if @rule.save
      respond_to do |format|
        format.js { render json: { result: @rule, status: 'success' } }
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
    params.require(:rule).permit(:title)
  end

  def set_rule
    @rule = Rule.find(params[:id])
  end
end
