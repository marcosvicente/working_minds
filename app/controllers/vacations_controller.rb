class VacationsController < ApplicationController
  before_action :set_vacation, only: %i[ show edit update destroy ]

  def index
    @vacations = Vacation.all
    render json: @vactions, status: ok
  end

  def show
    render json: @vacation, status: ok
  end

  def create
    @vacation = Vacation.new(vacation_params)
    if @vacation.save
      render json: @vacation, status: :created
    else
      render json: @vacation.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    if @vacation.update(vacation_params)
      render json: @vacation, status: :created
    else
      render json: @vacation.errors.full_messages, status: :unprocessable_entity
    end
  end

  def delete
  end

  private

  def set_vacation
    @vacation = Vacation.find(params[:id])
  end

  def vacation_params
    params.require(:vacation).permit(
      :date_init,
      :date_end,
      :employee_id
    )
  end
end
