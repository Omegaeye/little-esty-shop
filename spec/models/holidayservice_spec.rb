require 'rails_helper'

RSpec.describe HolidayService, type: :model do
  describe "Holiday Service with attributes" do
    it "Holiday service instances and class " do
      expect(HolidayService.holiday_instances.class).to eq(Array)
      expect(HolidayService.holiday_instances.first.class).to eq(Holiday)
    end
  end


end
