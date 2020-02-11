# Application Challange
This app is created for the Application Challenge located at [shastic/coding-challenges](https://bitbucket.org/shastic/coding-challenges)

## Setup
You need Docker to run this app.

```bash
git clone https://github.com/Abduvakilov/application_challenge.git && cd application_challenge
docker-compose build
docker-compose up -d
docker-compose exec shastic_challenge bundle exec ruby 'app.rb' -e 'call'
```

## Description
The app is created with the latest but minimal dependencies at the time.
There is 3 services. The `shastic_challenge` service takes data from `fake_api` service and records them at `mysql`.
`shastic_challange` uses `ActiveRecord` without rails. Has `rspec` for tests. Tests cover major part of the app. Lint by `rubocop`
`fake_api` uses `sinatra`.

### Unclear Points
The following were unclear points and what I assumed they mean

`"Please clear up the referrerName response field value before saving, it should validate with following regex:"`
Remove the 'referrerName' field if the field is invalid

`"Pageviews should be sorted by timestamp field, in ascending order."`
Sort Pageviews by timestamp when saving to database

`"Please ensure that pages are unique, and there are no duplicates."`
Remove pageviews that have the same 'pageID' and save only the first ordered by 'timestamp'.
