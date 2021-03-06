# Admin Form

A set of useful mixins, styles, and client-side views to build generic admin UI. Used in Sections, Organizations, Article "admin panel", and other generic CRUD UI that you don't want to design.

![](https://s3.amazonaws.com/f.cl.ly/items/1c3G2e2x3M0i1G2R3f11/Image%202015-07-10%20at%204.39.25%20PM.png)

## Example

````jade
include ../components/admin_form/index

block content
  - model = section
  section.admin-form-section
    .admin-form-left
      h1 Section Details
      h2 General details that apply to all sections.
    .admin-form-right
      .admin-form-right-col
        +form-elements([
          { attr: 'title', type: 'input' },
          { attr: 'description', type: 'textarea' },
          { attr: 'thumbnail_url', type: 'image' },
          { attr: 'featured', type: 'checkbox' },
          { attr: 'end_at', type: 'date' }
        ])
  unless section.isNew()
    a.avant-garde-button.admin-delete Delete Section
````

````coffeescript
AdminEditView = require '../components/admin_form/index.coffee'
new AdminEditView
  el: $('body')
  model: @section
  onDeleteUrl: '/sections'
````