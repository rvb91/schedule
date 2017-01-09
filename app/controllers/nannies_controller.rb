class NanniesController < ApplicationController
  def index
    @start_time = params[:start_time].present? ? parse_datetime(params[:start_time]) : Time.now + 1.days
    @end_time = params[:end_time].present? ? parse_datetime(params[:end_time]) : @start_time + 10.days

    @nannies = Nanny.joins(:slots).
                    where("slots.start_time >= ? && slots.end_time <= ?", @start_time, @end_time).
                    includes(:slots).
                    order("slots.start_time ASC").
                    merge(Slot.reserveable)
  end

  def show
    @nanny = Nanny.find(params[:id])
  end

  def reserve
    @slot = Slot.includes(:nanny).find(params[:id])
    family = current_user.family
    nanny = @slot.nanny

    if @slot.can_reserve? && @slot.reserve_for(family)
      redirect_to nannies_path, notice: "successfully reserved #{nanny.name} from #{helpers.format_time(@slot.start_time)} to #{helpers.format_time(@slot.end_time)}"
    else
      redirect_to nannies_path(nanny), alert: "slot cannot be reserved"
    end
  end

  def cancel
  end

  def parse_datetime(hash)
    datetime = []
    datetime << hash[:year]
    datetime << hash[:month]
    datetime << hash[:day]
    datetime << hash[:hour]
    datetime << hash[:minute]
    DateTime.strptime(datetime.join("-"), "%Y-%m-%d-%H-%M")
  end
end
