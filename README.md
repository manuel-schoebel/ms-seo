ms-seo
======

An SEO helper package for Meteor.js. Originally posted as an article here: [manuel-schoebel.com/blog/meteor-and-seo](http://www.manuel-schoebel.com/blog/meteor-and-seo "Meteor.js and SEO")

Installation
----
This package is on Atmosphere:

    meteor add linguahouse:ms-seo

Configuration
----
You can set some standard values. This will be set if nothing else is available.

```js
Meteor.startup(function() {
    if (Meteor.isClient) {
        return SEO.config({
            title: 'Manuel Schoebel - MVP Development',
            meta: {
                'description': 'Manuel Schoebel develops Minimal Viable Producs (MVP) for Startups'
            },
            og: {
                'image': 'http://manuel-schoebel.com/images/authors/manuel-schoebel.jpg' 
            }
        });
    }
});
```
    
As you can see, a meta tag in the head area is defined by a key and a value and it works the same way for the Open Graph 'og' tags.

Static SEO Data
----
The SEO data for your static sites which do not have dynamic content are set in a collection called 'SeoCollection'. Every document must have a 'route_name' that relates to a named route of your Iron-Router routes.

```js
SeoCollection.update(
    {
        route_name: 'aboutMe'
    },
    {
        $set: {
            route_name: 'aboutMe',
            title: 'About - Manuel Schoebel',
            meta: {
                'description': 'Manuel Schoebel is an experienced web developer and startup founder. He develops but also consults startups about internet topics.'
            },
            og: {
                'title': 'About - Manuel Schoebel',
                'image': 'http://manuel-schoebel.com/images/authors/manuel-schoebel.jpg'
            }
        }
    },
    {
        upsert: true
    }
);
```    

If a route changes, the SEO package automatically fetches the new data from this collection and sets all tags.

Dynamic SEO Data
----
Often times you want to set your SEO data dynamically, for example if you have a blog and you want that the documents title is equal to the blogposts title. You can do this easily in the Iron-Router after hook like this:

```js
Router.map(function() {
  return this.route('blogPost', {
    path: '/blog/:slug',
    waitOn: function() {
      return [Meteor.subscribe('postFull', this.params.slug)];
    },
    data: function() {
      var post;
      post = Posts.findOne({
        slug: this.params.slug
      });
      return {
        post: post
      };
    },
    onAfterAction: function() {
      var post;
      // The SEO object is only available on the client.
      // Return if you define your routes on the server, too.
      if (!Meteor.isClient) {
        return;
      }
      post = this.data().post;
      SEO.set({
        title: post.title,
        meta: {
          'description': post.description
        },
        og: {
          'title': post.title,
          'description': post.description
        }
      });
    }
  });
});
```

You can use the `SEO.set(object)` method and the object param looks the same as a document of the 'SeoCollection' but has no route_name.

Rel Author for Google Authorship
----
You can configure google authorship easily with

    rel_author: 'https://www.google.com/+ManuelSchoebel'

The output in your header will be the rel author link like this:

    <link href="https://www.google.com/+ManuelSchoebel" rel="author">

You can use 'rel_author' in the configuration, SeoCollection entries or in SEO.set as well.

## Multiple Meta Tags
For example for og:image you might want to have multiple image meta tags for one site. You can do this now by simply setting the og.image value to an array like this:

    SEO.set({
        ...
        og: {
          'image': ['http://www.your-domain.com/my-image-1.jpg', 'http://www.your-domain.com/my-image-2.jpg']
        }
    });

    // results in:
    <meta property="og:image" content="http://www.your-domain.com/my-image-1.jpg">
    <meta property="og:image" content="http://www.your-domain.com/my-image-2.jpg">

##Automatically set twitter and og meta tags like Title
For a page you normally have exactly one title you want to use for the og:title and twitter:title meta tags. MS-SEO does this automatically for your title, url and descrption. For the description, just set the meta-description tag.

You can also disable this in the settings:

```js
Meteor.startup(function() {
  SEO.config({
    ...
    auto: {
      twitter: false,
      og: true,
      set: ['description', 'url', 'title']
    }
  });
});
```

In this settings only the og metas are set automatically but not for twitter. The "set" array specifies what should be set. You could put any meta-tag in there and it will automatically be set for og or twitter as well.

## Using ignore
You may run into a situation where you need to ignore certain tags (such as viewport meta tags). This can easily be done with MS-SEO by overwriting the standard ignore option:

```js
Meteor.startup(function() {
  SEO.config({
    ...
    ignore: {
      meta: ['fragment', 'viewport'],
      link: ['stylesheet', 'icon', 'apple-touch-icon']
    }
  });
});
```

Using this setting will cause MS-SEO to ignore all meta tags with 'viewport' in the name as well as the standard ignored tags.

You Need More?
----
If you have different needs regarding meta tags and SEO, please [add a feature request](issues).
