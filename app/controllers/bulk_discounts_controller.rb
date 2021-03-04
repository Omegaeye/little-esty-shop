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
   bulk = Bulkdiscount.create(bulkdiscount_params)
    if bulk.save
      redirect_to merchant_dashboard_index_path
    else
      flash[:notice] = bulk.errors.full_messages
      render [:new]
    end
  end



  private
  def bulkdiscount_params
    params.permit(:percent, :quantity_threshold, status: 0)
  end
end
