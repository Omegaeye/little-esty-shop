class HolidayService

  def self.get_data
    response = Faraday.get("https://date.nager.at/Api/v2/NextPublicHolidays/US")
    data = response.body
    json = JSON.parse(data, symbolize_names: true)
  end

  def self.holiday_instances
    get_data[0..2].map do |data|
      Holiday.new(data)
    end
  end

end
