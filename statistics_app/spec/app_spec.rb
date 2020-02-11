# frozen_string_literal: true

require_relative '../app'

describe App do
  %i[sort unique position].each do |key|
    it "gets pageview #{key} key" do
      expect(App.pageview_keys[key]).not_to be_empty
    end
  end
  it 'gets statistics json' do
    expect(App.get_statistics_json(ENV['API_URI'])).to be_kind_of(Array)
  end
  context 'when filtering data' do
    let(:filtered_data) do
      require 'json'
      file = File.read File.join(File.dirname(__FILE__), 'example.json')
      App.filter_fields JSON.parse(file)
    end
    it 'gets correct fields on first visit element' do
      expect(filtered_data.first).to include(
        'visitorId' => 'e280af5191b64f18', 'idVisit' => '134853732',
        'idSite' => '209', 'visitIp' => '24.6.5.33'
      )
    end

    it 'runs and saves records' do
      system('ruby ../app.rb')
    end

    %w[
      visitorTypeIcon visitConverted visitConvertedIcon visitCount
      firstActionTimestamp visitEcommerceStatus visitEcommerceStatusIcon
      daysSinceFirstVisit daysSinceLastEcommerceOrder
    ].each do |key|
      it "removes #{key} field on second visit element" do
        expect(filtered_data.second).not_to have_key(key)
      end
    end

    it 'sorts pageviews in ascending order' do
      expect(filtered_data[0]['actionDetails'].third).to include('timestamp' => 1537623917)
    end

    it 'gets correct fields on third (by  timestamp) pageview element' do
      expect(filtered_data[0]['actionDetails'][2]).to include(
        'url' => 'https://apptest.loanspq.com/vl/VehicleLoan.aspx/vehicle-loan-information?lenderref=Meriwest_test&l=1',
        'pageTitle' => 'Vehicle Loan Information',
        'timeSpent' => '1', 'timestamp' => 1537623917
      )
    end

    %w[
      type pageIdAction serverTimePretty pageId
      generationTime timeSpentPretty icon
    ].each do |key|
      it "removes #{key} field on fifth pageview element" do
        expect(filtered_data[1]['actionDetails'][0]).not_to have_key(key)
      end
    end
  end
end
