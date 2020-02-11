# frozen_string_literal: true

require_relative '../../models/visit'

describe Visit do
  it 'gets field mapping' do
    expect(Visit.field_mapping).to be_kind_of(Hash)
  end

  it 'gets pageviews source key as String' do
    expect(Visit.pageviews_source_key).to be_kind_of(String)
  end

  it 'gets pageviews source key not empty' do
    expect(Visit.pageviews_source_key).not_to be_empty
  end

  context 'when creating record' do
    let(:visits) {
      [
        { visit_ip: '157.44.95.38', pageviews_attributes:
          [
            { title: 'good page' },
            { time_spent: '2 min' }
          ]
        },
        { vendor_site_id: 1789, pageviews_attributes:
          [
            { position: 6 }
          ]
        }
      ]
    }

    it 'creates pageview with nested attributes' do
      expect { Visit.create(visits) }
        .to change(Pageview, :count).by(3).and change(Visit, :count).by(2)
    end

    it 'sets correct visit_id for pageviews' do
      records = Visit.create(visits)
      expect(records[1].pageviews[0].visit_id).to eq(records[1].id)
    end
  end

  it 'maps fields' do
    visit = Visit.new(idVisit: 15615)
    visit.idSite = '485415'
    visit.save
    expect(visit).to have_attributes(vendor_visit_id: '15615', vendor_site_id: '485415')
  end

  it 'matches evid pattern' do
    visit = Visit.create(
      evid: 'evid_TEOJeLsw-EmQA-yZH^-[Vri-1acNvlKN5cB7',
      vendor_site_id: 20484
    )
    expect(visit).to have_attributes(
      evid: 'TEOJeLsw-EmQA-yZH^-[Vri-1acNvlKN5cB7',
      vendor_site_id: '20484'
    )
  end

  it 'removes incorrect evid' do
    visit = Visit.create(
      evid: 'evid_TEOJeLswincorrrrect-[Vri-1acNvlKN5cB7', vendor_site_id: 20484
    )
    expect(visit).to have_attributes(evid: nil, vendor_site_id: '20484')
  end
end
