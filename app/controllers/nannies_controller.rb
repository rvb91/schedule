class NanniesController < ApplicationController
  def index
    @start_time = params[:start_time].present? ? parse_datetime(params[:start_time]) : Time.now + 1.days
    @end_time = params[:end_time].present? ? parse_datetime(params[:end_time]) : @start_time + 12.day

    @nanny_ids = Slot.where("start_time >= ? && end_time <= ?", @start_time, @end_time)
                     .reserveable
                     .select("slots.nanny_id").distinct

    @nannies = Nanny.where(id: @nanny_ids)
  end

  def show
    @nanny = Nanny.find(params[:id])
  end

  def reserve
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
