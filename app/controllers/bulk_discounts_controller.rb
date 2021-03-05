class BulkDiscountsController < ApplicationController

  def index
    @merchant = Merchant.find(params[:merchant_id])
    @bulkdiscounts = @merchant.bulk_discounts
    @holidayservices = HolidayService.holiday_instances
  end

  def show
    @bulkdiscount = BulkDiscount.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
   @merchant = Merchant.find(params[:merchant_id])
   bulk = @merchant.bulk_discounts.create(bulkdiscount_params)
    if bulk.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = bulk.errors.full_messages
      render :new
    end
  end

  def destroy
    @merchant = Merchant.find(params[:merchant_id])
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end



  private
  def bulkdiscount_params
    params.permit(:percent, :quantity_threshold, :status)
  end
end
