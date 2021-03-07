class BulkDiscountsController < ApplicationController
  before_action :find_merchant


  def index
    @bulkdiscounts = @merchant.bulk_discounts
    @holidayservices = HolidayService.holiday_instances
  end

  def show
    @bulkdiscount = BulkDiscount.find(params[:id])
  end

  def new

  end

  def edit
    @bulkdiscount = BulkDiscount.find(params[:id])
  end

  def create
   bulkdiscount = @merchant.bulk_discounts.create(bulkdiscount_params)
    if bulkdiscount.save
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:notice] = bulkdiscount.errors.full_messages
      render :new
    end
  end

  def update
    discount = BulkDiscount.find(params[:id])
    discount.update(bulkdiscount_params)
    redirect_to merchant_bulk_discount_path(@merchant, discount)

  end

  def destroy
    BulkDiscount.destroy(params[:id])
    redirect_to "/merchant/#{@merchant.id}/bulk_discounts"
  end



  private
  def bulkdiscount_params
    params.permit(:percent, :quantity_threshold, :status)
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end
