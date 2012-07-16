bestsigs-wow-cacher
===================

Uses the [Best Signatures API](http://www.best-signatures.com/api/) to
generate, display, and refresh World of Warcraft character signature
graphics.

How it works
------------

[Best Signatures](http://www.best-signatures.com/wow/) is my personal
favorite forum signature image generator for [World of
Warcraft](http://us.battle.net/wow/) forums, but its biggest flaw is
that it doesn't automatically refresh images. It does provide an
[API](http://www.best-signatures.com/api/), which is rate-limited to ten
requests per character per day.

What this simple [Sinatra](http://www.sinatrarb.com/) app does is:

  1. Take a region, realm, and character name as part of the URL (e.g.,
     `http://bestsigs-wow-cacher.herokuapp.com/us/Earthen+Ring/Adarystus.png`),
     and builds a Best Signatures API request URI.

  2. Make a request to the Best Signatures API, which causes a signature
     image to be generated and saved, and caches the URI of the
     generated image for the character.

  3. Serve up the generated image from the cached URI for the character
     for the next few hours.

  4. After a time delay (currently six hours), makes another API request
     the next time the character's image is requested, generating a new
     image, and caches the new image's URI (replacing the URI of the old
     image).

How to use it
-------------

The [homepage](http://bestsigs-wow-cacher.herokuapp.com/) now includes
an HTML form that can be used to generate the image URL given the
region, realm name, and character name.

What the image URLs look like:

    http://bestsigs-wow-cacher.herokuapp.com/us/Earthen Ring/Adarystus.png

Replace `us` with your region (e.g., `eu`, `kr`). Replace `Earthen Ring`
with your realm name (e.g. `Spinebreaker`). Replace `Adarystus` with
your character name (e.g. `Vqshorkhas`). Use the URL in an image tag in
a forum signature or on a web page.

A BBCode usage sample:

    [URL="http://us.battle.net/wow/en/character/earthen-ring/Adarystus/"][IMG="http://bestsigs-wow-cacher.herokuapp.com/us/Earthen Ring/Adarystus.png"][/URL]

What the image looks like:

![US-Earthen Ring/Adarystus](http://bestsigs-wow-cacher.herokuapp.com/us/Earthen%20Ring/Adarystus.png)

What it doesn't do yet
----------------------

  * Let you specify what kind of signature graphic to generate. I have
    lots of characters and like having them all displayed, and I prefer
    a row of spherical portrait icons.

  * Let you specify any customization at all for the signature graphic.

  * Let you force it to refresh. Depending on performance, I may shorten
    the refresh time to come closer to the API rate limit.

  * Cache the actual signature image; it just downloads and regurgitates
    the image from the URL provided in the API response. Not the most
    efficient, I know; I'll come up with something faster (and still
    free) soon enough.
