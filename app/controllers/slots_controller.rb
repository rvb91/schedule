class SlotsController < ApplicationController
  before_action :set_slot, only: [:show, :edit, :update, :destroy]

  def index
    @slots = current_user.nanny.slots
  end

  def show
  end

  def new
    @slot = Slot.new
    @slot.start_time = Time.now + Slot::START_BUFFER + 5.minutes
    @slot.end_time = @slot.start_time + Slot::MINIMUM_DURATION
  end

  def edit
    return slots_path, notice: "This slot has been reserved and cannot be changed" unless @slot.can_edit?(current_user.nanny)
  end

  def create
    @slot = Slot.new(slot_params)
    @slot.nanny = current_user.nanny

    respond_to do |format|
      if @slot.save
        format.html { redirect_to slots_path, notice: 'Slot was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    if @slot.can_edit?(current_user.nanny)
      if @slot.update(slot_params)
        return redirect_to @slot, notice: 'Slot was successfully updated.'
      end
    else
      flash[:error] = "Slot has been reserved and cannot be changed"
    end
    return render :edit
  end

  def destroy
    if @slot.can_cancel?(current_user.nanny) && @slot.destroy
      redirect_to slots_url, notice: 'Slot was successfully deleted.'
    else
      redirect_to slots_path, alert: "You cannot delete a slot that has been reserved"
    end
  end

  private

    def set_slot
      @slot = Slot.find(params[:id])
    end


    def slot_params
      params.require(:slot).permit(:start_time, :end_time)
    end
end
