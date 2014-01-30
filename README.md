ms-seo
======

A seo helper package for meteor.js

Prerequisites
======
You need to add the Iron-Router package.

    mrt add iron-router


Installation
----
This package is not on meteorite, yet. Add this repository to your smart.json file.

    "ms-seo": {
      "git": "https://github.com/DerMambo/ms-seo"
    },

Configuration
----
You can set some standard values. This will be set if nothing else is available.

    Meteor.startup(function() {
      return SEO.config({
        title: 'Manuel Schoebel - MVP Development',
        meta: [
          {
            key: 'description',
            value: 'Manuel Schoebel develops Minimal Viable Producs (MVP) for Startups'
          }
        ],
        og: [
          {
            key: 'image',
            value: 'http://manuel-schoebel.com/images/authors/manuel-schoebel.jpg'
          }
        ]
      });
    });
    
As you can see a meta tag in the head area is defined by a key and a value and it works the same way for the Open Graph 'og' tags.

Static SEO Data
----
The SEO data for your static sites which do not have dynamic content are set in a collection called 'SeoCollection'. Every document must have a 'route_name' that relates to a named route of your Iron-Router routes.

    SeoCollection.insert({
      route_name: 'aboutMe',
      title: 'About - Manuel Schoebel',
      meta: [
        {
          key: 'description',
          value: 'Manuel Schoebel is an experienced web developer and startup founder. He develops but also consults startups about internet topics.'
        }
      ],
      og: [
        {
          key: 'title',
          value: 'About - Manuel Schoebel'
        },
        {
          key: 'image',
          value: 'http://manuel-schoebel.com/images/authors/manuel-schoebel.jpg'
        }
      ]
    });

If a route changes, the SEO package automatically fetches the new data from this collection and sets all tags.

Dynamic SEO Data
----
Often times you want to set your SEO data dynamically, for example if you have a blog and you want that the documents title is equal to the blogposts title. You can do this easily in the Iron-Router after hook like this:


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
        after: function() {
          var post;
          // The SEO object is only available on the client.
          // Return if you define your routes on the server, too.
          if (!Meteor.isClient) {
            return;
          }
          post = this.data().post;
          SEO.set({
            title: post.title,
            meta: [
              {
                key: 'description',
                value: post.description
              }
            ],
            og: [
              {
                key: 'title',
                value: post.title
              }, 
              {
                key: 'description',
                value: post.description
              }
            ]
          });
        }
      });
    });

You can use the SEO.set(object) method and the object param looks the same as a document of the 'SeoCollection' but has no route_name.

Rel Author for Google Authorship
----
You can configure google authorship easily with

    rel_author: 'https://www.google.com/+ManuelSchoebel'

The output in your header will be the rel author link like this:

    <link href="https://www.google.com/+ManuelSchoebel" rel="author">

You can use 'rel_author' in the configuration, SeoCollection entries or in SEO.set as well.
