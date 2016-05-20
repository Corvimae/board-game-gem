# board-game-gem
board-game-gem provides a Ruby interface to the [BoardGameGeek XML API](http://www.boardgamegeek.com/xmlapi2) (version 2). It's designed to work with the Rails cache to reduce the number of requests when working with Rails.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'board-game-gem'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install board-game-gem

## Usage

Requests to retrieve data can be made using any of the methods in the BoardGameGem module. Arguments in brackets are optional.

The `options` argument is a hash which allows any other parameter. For example, if you wished to limit a collection by subtype, you could pass the hash `{ subtype: "boardgame" }` as `options`.

---

`get_item(id, [statistics], [api] [options])`: Retreive a specific item from BGG by ID. Within the BGG API, this is called a 'thing' rather than an 'item'. If an item with that ID is not found, `nil` is returned.

If `statistics` is true, averages, weights, and rankings will be retrieved as well. By default, `statistics` is false and `api` is 2.

`get_item` returns a `BGGItem` object, which has the following attributes:
`id, api, type, thumbnail, name, alternate_names, description, year_published, min_players, max_players,
playing_time, min_playing_time, max_playing_time, statistics`. If `api` is 1, `alternate_names` will always be `nil`.

`statistics` is a hash, with the following keys: `:user_ratings, :average, :bayes, :ranks, :stddev, :median, :owned, :trading, :wanted, :wishing, :num_comments, :num_weights, :average_weight`. Within this, `:ranks` is an array, containing hashes with the following keys: `:type, :name, :friendly_name, :value, :bayes`.

`get_items(ids, [statistics], [api], [options])` exists as well, which is functionally equivelent to `get_item`, except it takes
an array of IDs and returns an array of `BGGItem` objects. `get_items` should be used when making many requests in succession,
as it makes one HTTP request for the batch.

---

`get_family(id, [options])`: Retrieves information on a data family. Returns a `BGGFamily` object, which has the following attributes: `id, thumbnail, image, name, alternate_names, description`. Within this, `alternate_names` is an array of strings. If a family with that ID is not found, `nil` is returned.

---

`get_user(username, [options])`: Retreives information on a specific user by name. If a user with that name does not exist, `nil` is returned.

`get_user` returns a `BGGUser` object, which has the following attributes: `id, name, avatar, year_registered, last_login, state, trade_rating`

#### Methods
`get_collection`: Returns this user's collection, as if `BoardGameGem.get_collection` was called using this user's name.

---

`get_collection(username, [options])`: Returns a user's collection by username. Returns a `BGGCollection` object, which has two attributes: `:count`, the number of items in the collection, and `:items`, an array consisting of many `BGGCollectionItem` objects.

The BGG API queues requests to retrieve a user's collection, returning a 202 status code and a 'please wait' message. When BoardGameGem makes a request and sees a 202 code, it waits a short time before issuing the request again. After 10 tries, BoardGameGem will give up and return `nil`. **You should not make multiple `get_collection` requests to handle queueing yourself.**

#### Methods
`get_owned`: Returns itmes in this collection that are flagged as 'owned'.

`get_previously_owned`: Returns items in this collection that are flagged as 'previously owned'.

`get_wants`: Returns items in this collection that are flagged as 'want'.

`get_want_to_play`: Returns items in this collection that are flagged as 'want to play'.

`get_want_to_buy`: Returns items in this collection that are flagged as 'want to buy'.

`get_wishlist`: Returns items in this collection that are on the collection owner's wishlist.

`get_preordered`: Returns items in this collection that are flagged as 'preordered'.

#### BGGCollectionItem

The BGG API returns a subset of an item's data when including it in a collection request. As a result, a `BGGCollectionItem` contains the following attributes: `id, type, name, year_published, image, thumbnail, num_players, status, num_plays`. Within this, `status` is a hash containing the following keys: `:own, :prev_owned, :for_trade, :want, :want_to_play, :want_to_buy, :wishlist, :preordered:, :last_modified`. 

`BGGCollectionItem` contains one other method, `to_item([statistics])`, which returns the `BGGItem` version of this object.

---

`search(query, [options])`: Performs a search request, returning any items which are like the query. Returns a hash with the keys `total`, the number of items found in the search, and `items`, an array of `BGGSearchResult` objects.

#### BGGSearchResult

Much like `BGGCollectionItem`, `BGGSearchResult` is a subset of `BGGItem`, and contains the following attributes: `id, type, name, year_published`.

A `BGGItem` version of this object can be requested with `to_item([statistics])`.

### But the BGG API has more than just this!

I made this gem to help make requests for another one of my projects, [Acceptable Trader](http://www.github.com/acceptableice/acceptable-trader), and thus haven't finished implementing the other BGG API features that Acceptable Trader didn't require. If you need something specific for your application, log an issue, message me on Twitter ([@AcceptableIce](http://www.twitter.com/acceptableice)), or email me at [jakeroussel@mac.com](mailto:jakeroussel@mac.com). This is my first gem, so there are probably some issues. Let me know!

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/acceptableice/board-game-gem. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

