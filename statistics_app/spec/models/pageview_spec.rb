# frozen_string_literal: true
require_relative '../../models/visit'

describe Pageview do
  it 'gets field mapping' do
    expect(Visit.field_mapping).to be_kind_of(Hash)
  end

  it 'creates records' do
    pageviews = [
      { title: 'good page' },
      { time_spent: '6 min' },
      { position: 6 }
    ]
    expect { Pageview.create(pageviews) }.to change(Pageview, :count).by(3)
  end

  it 'maps fields' do
    pageview = Pageview.new(pageTitle: 'Some fancy title')
    pageview.timeSpent = '2 min'
    pageview.save
    expect(pageview).to have_attributes(
      title: 'Some fancy title', time_spent: '2 min'
    )
  end
end
