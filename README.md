# Zensearch
## Background
Requirements:

 - command line application
 - search the data
 - return results in human readable format
 - (where data exists) values from related entites should be included in the results
 - search using any field
   - full value matching
   - empty value matching

Hi there and welcome Zendesk code reviewer!

This challenge felt a little open-ended to me, but given the line:
  "Search can get pretty complicated pretty easily, we just want to see that you can code a basic search application."

I thought my time (at least initially) would be best invested in exploring the nuances of the data and any resulting complexities of the searching, in preference to satisfying your last two evaluation criteria (ie. "Performance" and "Robustness").
ie. to write somethings as simple as possible, to quickly learn as much about the problem I'm trying to solve before attempting to make it more performant or robust.

For this reason, although giving it some initial thought, I decided against reaching for an sql (or nosql) database and just worked in memory.

I was also instructed to use the language in which I'm strongest, which for me would have been ruby.

However after having used `jq` (a lightweight and flexible command-line JSON processor) several times before, at a very basic level - but seeing glimpses of what its capable of doing.  And with the requirement that this be a command-line tool.  I (selfishly) saw this as a good opportunity to challenge myself to use (and learn more about) the functional programming language used in `jq` at a more advanced level and see if it could actually be done.  (Plus I've never worked in a purely functional programming language.)

And I figured if I'm going to use `jq` on the command line, then why not challenge myself even more and write all the surrounding code in `bash`.

Haha - well I guess it was meant to be a "Coding Challenge".


## Data

- `tickets.json`
- `users.json`
- `organizations.json`


## Getting Started

Requirements:

- `bash` (using v3.2)
- `jq` v1.6 (https://stedolan.github.io/jq/download/)
- `dialog` (`brew install dialog` or visit https://invisible-island.net/dialog/dialog.html"

Testing:

- `make test`
  - installs & runs `shpec` (https://github.com/rylnd/shpec - a shell script testing library I co-authored)

Running:

- `./zen_search`  (a simple text menu)
- `./zen_search2` (a curses based menu using `dialog` - https://invisible-island.net/dialog/dialog.html)


## My Method & Approach
My first goal was to fail fast with this choice of `jq`, to see if it was even possible to:

- search the data from the command line
  => definitely, that's what `jq` was built for
- return results in human readable format
  => `jq` can pretty print json, as well as rendering other formats such as tsv
- (where data exists) values from related entites should be included in the results
  => I learnt that `jq` has a feature where additional data can be "slurped" from additional files
- search using any field
  => there appeared to be strings, integers, booleans and arrays in the data whic were fine, although arrays were a little trickier.
 - full value matching
    => no problem
 - empty value matching
    => `jq` has a "null" which should do the job

`jq` appeared to get over most of these hurdles quite easily...
eg.

- `jq '.[] | select(.status=="solved")' tickets.json`
- `jq --raw-output '.[] | select(.tags | index("Oregon")) | .tags | @csv' tickets.json`

or if we don't want to worry about whether the key we're searching for is an `array`, `integer` or `boolean` then just blindly array-ercize it before searching:

- `jq --raw-output '.[] | select([.status] | flatten | index("solved")) | .tags | @csv' tickets.json`
- `jq --raw-output '.[] | select([.tags]   | flatten | index("Oregon")) | .tags | @csv' tickets.json`


And, although there was a bit of a learning curve, it could augment data from related entities without too much code.

- `jq --slurpfile organizations organizations.json '([ $organizations[0][] | { (._id|tostring): .name } ] | add) as $organization_names | .[] | . + { organization: $organization_names[.organization_id|tostring] }' users.json`

Which I then discovered the `jq` code could be separated out into its own file.

- `jq --slurpfile organizations organizations.json -f users.jq users.json`

Where `users.jq` contains the following `jq` code:
```
(
  [
    $organizations[0][] |
    { (._id|tostring): .name }
  ] |
  add
) as $organization_names |
.[] |
. +
{ organization: $organization_names[.organization_id|tostring] }
```

And apart from some funkyness needed to convert `integers` to `strings` when creating `hash` keys, the code seemed pretty neat.

It was even possible to pass arguments in to the code like so:

- `jq --argjson value 12 --slurpfile organizations organizations.json -f users.jq users.json`

```
(
  [
    $organizations[0][] |
    { (._id|tostring): .name }
  ] |
  add
) as $organization_names |
.[] |
select(._id==$value) |
. +
{ organization: $organization_names[.organization_id|tostring] }
```

`jq length users.json`
```
75
```

Make some more users to test performance:

 - `jq '[range(0;150) as $i | .[] | . + { "_id": (._id + $i * 100) }]' users.json > users-11250.json`

`jq length users-11250.json`
```
11250
```

`jq length organizations.json`
```
25
```

## TODO

- Scalability => I notice dialog is a little slow to render large lists of users, so perhaps use some pagination.
- Add some validations to the data, *but* I'd first need to find out what valid data actually looks like.
  - eg. what assumptions do we make about `_id` types, or date formats, or tag values?
  - BTW just what is with the unicodes scattered amongst the data?
  - FYI there is a `Ticket#requester_id` `Ticket#recipient` mention in the PDF, but I can't seem to find them anywhere in the data.

