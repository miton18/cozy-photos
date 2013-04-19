app = require 'application'
BaseView = require 'lib/base_view'
Gallery = require 'views/gallery'
{editable} = require 'lib/helpers'

module.exports = class AlbumView extends BaseView
    template: require 'templates/album'

    id: 'album'
    className: 'container-fluid'

    events: =>
        'click   a.delete' : @destroyModel
        'click   a.clearance' : @changeClearance

    getRenderData: ->
        clearanceHelpers = @clearanceHelpers(@model.get 'clearance')
        _.extend {clearanceHelpers: clearanceHelpers}, @model.attributes

    afterRender: ->
        @gallery = new Gallery
            el: @$ '#photos'
            editable: @options.editable
            collection: @model.photos
            beforeUpload: @beforePhotoUpload

        @gallery.render()

        @makeEditable() if @options.editable

    # save album before photos are uploaded to it
    # store albumid in the photo
    beforePhotoUpload: (callback) =>
        @saveModel().then =>
            callback albumid: @model.id

    # make the divs editable
    makeEditable: =>
        @$el.addClass 'editing'

        help =  @clearanceHelpers @model.get 'clearance'

        @$('.clearancehelper').popover 'destroy'

        @$('.clearancehelper').popover
            trigger: 'click'
            placement: 'bottom'
            title: help.Title
            content: help.content

        editable @$('#title'),
            placeholder: 'Title ...'
            onChanged: (text) => @saveModel title: text

        editable @$('#description'),
            placeholder: 'Write some more ...'
            onChanged: (text) => @saveModel description: text

    destroyModel: ->
        if @model.isNew()
            return app.router.navigate 'albums', true

        if confirm 'Are you sure ?'
            @model.destroy().then ->
                app.router.navigate 'albums', true

    changeClearance: ->
        clearance = @model.get 'clearance'
        newclearance = 'hidden'  if clearance is 'public'
        newclearance = 'private' if clearance is 'hidden'
        newclearance = 'public'  if clearance is 'private'
        helper =
        @saveModel(clearance: newclearance).then =>

            @$('.clearance').find('span').text newclearance

            help =  @clearanceHelpers newclearance

            @$('.clearancehelper').popover 'destroy'
            @$('.clearancehelper').popover
                trigger: 'click'
                placement: 'bottom'
                title: help.title
                content: help.content



    saveModel: (hash) ->
        promise = @model.save(hash)
        if @model.isNew()
            promise = promise.then =>
                app.albums.add @model
                app.router.navigate "albums/#{@model.id}/edit"

        return promise

    getPublicUrl: ->
        origin = window.location.origin
        path = window.location.pathname.replace 'apps', 'public'
        path = '/public/' if path is '/'
        return origin + path + window.location.hash

    clearanceHelpers: (clearance) ->
        if clearance is 'public'
            title: 'This album is public',
            content: 'It will appears on your homepage.'
        else if clearance is 'hidden'
            title: 'This album is hidden',
            content: "It will not appears on your homepage.
                But you can share it with the following url :
                #{ @getPublicUrl() }"
        else if clearance is 'private'
            title: 'This album is private',
            content: 'It cannot be accessed from the public side'
