bestsigs-wow-cacher
===================

[![Dependency Status](https://gemnasium.com/jbhannah/bestsigs-wow-cacher.png)](https://gemnasium.com/jbhannah/bestsigs-wow-cacher)

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
     `http://bestsigs-wow-cacher.herokuapp.com/us/Earthen Ring/Adarystus.png`).

  2. Build and make a request to the Best Signatures API, which causes
     a signature image to be generated, then writes the generate image
     to an Amazon S3 bucket.

  3. Serve up the generated image from Amazon S3 for the character for
     the next few hours.

  4. After a time delay (currently three hours), repeats steps 2 and 3
     to generate and save a new image.

How to use it
-------------

The [homepage](http://bestsigs-wow-cacher.herokuapp.com/) now includes
an HTML form that can be used to generate the image URL given the
region, realm name, and character name, as well as a BBCode snippet that
can be used directly in a forum post or signature.

What the image URLs look like:

    http://bestsigs-wow-cacher.herokuapp.com/us/Earthen Ring/Adarystus.png

Replace `us` with your region (e.g., `eu`, `kr`). Replace `Earthen Ring`
with your realm name (e.g. `Spinebreaker`). Replace `Adarystus` with
your character name (e.g. `Vqshorkhas`). Use the URL in an image tag in
a forum signature or on a web page. Only a single realm and character
can be specified in an image URL.

A BBCode usage sample:

    [url="http://us.battle.net/wow/en/character/Earthen Ring/Adarystus/"][img]http://bestsigs-wow-cacher.herokuapp.com/us/Earthen Ring/Adarystus.png[/img][/url]

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
