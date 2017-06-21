_ = require 'underscore'
benv = require 'benv'
sinon = require 'sinon'
Backbone = require 'backbone'
{ resolve } = require 'path'
React = require 'react'
ReactDOM = require 'react-dom'
ReactTestUtils = require 'react-addons-test-utils'
ReactDOMServer = require 'react-dom/server'
r =
  find: ReactTestUtils.findRenderedDOMComponentWithClass
  simulate: ReactTestUtils.Simulate

describe 'ImageCollection', ->

  beforeEach (done) ->
    benv.setup =>
      benv.expose $: benv.require 'jquery'
      $.fn.fillwidthLite = sinon.stub()
      global.HTMLElement = () => {}
      @ImageCollection = benv.require resolve(__dirname, '../index')
      Artwork = benv.requireWithJadeify(
        resolve(__dirname, '../components/artwork')
        ['icons']
      )
      Image = benv.requireWithJadeify(
        resolve(__dirname, '../components/image')
        ['icons']
      )
      RichTextCaption = benv.requireWithJadeify(
        resolve(__dirname, '../../../../../../../components/rich_text_caption/index')
        ['icons']
      )
      Image.__set__ 'RichTextCaption', React.createFactory RichTextCaption
      Controls = benv.require resolve(__dirname, '../components/controls')
      Controls.__set__ 'Autocomplete', sinon.stub()
      Controls.__set__ 'UrlArtworkInput', sinon.stub()
      @ImageCollection.__set__ 'Artwork', React.createFactory Artwork
      @ImageCollection.__set__ 'Image', React.createFactory Image
      @ImageCollection.__set__ 'Controls', React.createFactory Controls
      @ImageCollection.__set__ 'imagesLoaded', sinon.stub()
      @props = {
        section: new Backbone.Model
          type: 'image_collection'
          images: [
            {
              type: 'image'
              url: 'https://artsy.net/image.png'
              caption: '<p>Here is a caption</p>'
            }
            {
              type: 'artwork'
              title: 'The Four Hedgehogs'
              id: '123'
              image: 'https://artsy.net/artwork.jpg'
              partner: name: 'Guggenheim'
              artists: [
                {name: 'Van Gogh'}
              ]
            }
          ]
        editing: false
        setEditing: @setEditing = sinon.stub()
        channel: { hasFeature: hasFeature = sinon.stub().returns(true) }
      }
      @component = ReactDOM.render React.createElement(@ImageCollection, @props), (@$el = $ "<div></div>")[0], =>
      @component.fillwidth = sinon.stub()
      @component.removeFillwidth = sinon.stub()
      done()

  afterEach ->
    benv.teardown()

  it 'renders an image collection component with preview', ->
    $(ReactDOM.findDOMNode(@component)).find('img').length.should.eql 2
    $(ReactDOM.findDOMNode(@component)).html().should.containEql 'Here is a caption'
    $(ReactDOM.findDOMNode(@component)).html().should.containEql 'The Four Hedgehogs'

  it 'renders a placeholder if no images', ->
    @component.props.section.set 'images', []
    @component.forceUpdate()
    $(ReactDOM.findDOMNode(@component)).html().should.containEql 'Add images and artworks above'

  it 'renders a progress indicator if progress', ->
    @component.setState progress: .5
    $(ReactDOM.findDOMNode(@component)).html().should.containEql '"upload-progress" style="width: 50%;"'

  it 'sets editing mode on click', ->
    r.simulate.click r.find @component, 'edit-section-image-container'
    @setEditing.called.should.eql true
    @setEditing.args[0][0].should.eql true

  it '#removeItem updates the images array', ->
    @component.removeItem(@props.section.get('images')[0])()
    @props.section.get('images').length.should.eql 1

  xit '#onChange calls @fillwidth if > 1 image and layout overflow_fillwidth', ->
    @component.onChange()
    @component.fillwidth.called.should.eql true

  xit '#onChange calls @removefillwidth if < 1 image and layout overflow_fillwidth', ->
    @component.props.section.set 'images', []
    @component.onChange()
    @component.removeFillwidth.called.should.eql true

  xit '#onChange calls @removefillwidth if > 1 image and layout column_width', ->
    @component.props.section.set 'layout', 'column_width'
    @component.onChange()
    @component.removeFillwidth.called.should.eql true
