# Schedule

## Demo Link
[http://fast-oasis-31799.herokuapp.com/](http://fast-oasis-31799.herokuapp.com/)

##Assumptions Made: 
- 2 basic user types - Nannies and Families
- Nannies can create slots for when they are free. 
- Families can view all nannies and slots and reserve them.
- A user can be only be of 1 type. A nanny or family.
- Families have to book the entire duration of the nanny. No partials time slots allowed. Schema allows for this to change.
- The nanny can only have 1 time slots at at a time. no overlapping slots allowed. Example 
- Families can reserve overlapping slots.

## Limitations
- No time zone handling. Everyone is in the same timezone.
- Params sanitization in nannies controller. Its not required because we are not passing the params hash directly into the model. 
- Nannies cannot modify or delete a slot once it has been reserved. 
- Pagination is not needed because of the limited dataset.
- Model tests only.

## Setup
requires Rails 5, MySQL and Ruby 2.2.6

`bundle install --jobs=20`
`rake db:setup`
`rails server`

Run tests by running `rspec`





