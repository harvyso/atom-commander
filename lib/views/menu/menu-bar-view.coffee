MenuItem = require './menu-item'
{$, $$, View} = require 'atom-space-pen-views'

module.exports =
class MenuBarView extends View

  constructor: ->
    super();

  @content: ->
    @div {class: 'atom-commander-menu-bar'}, =>
      @div {class: 'buttons', outlet: 'content'}
      @div {class: 'extra-buttons'}, =>
        @button {tabindex: -1, class: 'btn btn-sm inline-block icon-gear', click: 'settingsPressed'}
      @div {outlet: 'details'}, =>
        @div {class: 'details'}, =>
          @div {class: 'column'}, =>
            @div '1 Select', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'selectAll'}, =>
                @div '1'
                @div 'All', {class: 'description'}
              @div {class: 'item', click: 'selectNone'}, =>
                @div '2'
                @div 'None', {class: 'description'}
              @div {class: 'item', click: 'selectAdd'}, =>
                @div '3'
                @div 'Add to selection...', {class: 'description'}
              @div {class: 'item', click: 'selectRemove'}, =>
                @div '4'
                @div 'Remove from selection...', {class: 'description'}
              @div {class: 'item', click: 'selectInvert'}, =>
                @div '5'
                @div 'Invert selection', {class: 'description'}
              @div {class: 'item', click: 'selectFolders'}, =>
                @div '6'
                @div 'Folders', {class: 'description'}
              @div {class: 'item', click: 'selectFiles'}, =>
                @div '7'
                @div 'Files', {class: 'description'}
          @div {class: 'column'}, =>
            @div '2 Go', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'goProject'}, =>
                @div '1'
                @div 'Project - Choose project folder to go to...', {class: 'description'}
              @div {class: 'item', click: 'goEditor'}, =>
                @div '2'
                @div 'Editor - Go to focused file in editor', {class: 'description'}
              @div {class: 'item', click: 'goDrive'}, =>
                @div '3'
                @div 'Drive - Choose drive to go to...', {class: 'description'}
              @div {class: 'item', click: 'goRoot'}, =>
                @div '4'
                @div 'Root - Go to current folder\'s root folder', {class: 'description'}
              @div {class: 'item', click: 'goHome'}, =>
                @div '5'
                @div 'Home - Go to user\'s home folder', {class: 'description'}
          @div {class: 'column'}, =>
            @div '3 Bookmarks', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'bookmarksAdd'}, =>
                @div '1'
                @div 'Add', {class: 'description'}
              @div {class: 'item', click: 'bookmarksRemove'}, =>
                @div '2'
                @div 'Remove', {class: 'description'}
              @div {class: 'item', click: 'bookmarksOpen'}, =>
                @div '3'
                @div 'Open', {class: 'description'}
          @div {class: 'column'}, =>
            @div '4 Servers', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'serversAdd'}, =>
                @div '1'
                @div 'Add', {class: 'description'}
              @div {class: 'item', click: 'serversRemove'}, =>
                @div '2'
                @div 'Remove', {class: 'description'}
              @div {class: 'item', click: 'serversOpen'}, =>
                @div '3'
                @div 'Open', {class: 'description'}
              @div {class: 'item', click: 'serversClose'}, =>
                @div '4'
                @div 'Close', {class: 'description'}
              @div {class: 'item', click: 'serversEdit'}, =>
                @div '5'
                @div 'Edit', {class: 'description'}
              @div {class: 'item', click: 'serversCache'}, =>
                @div '6'
                @div 'Cache - View cached files', {class: 'description'}
          @div {class: 'column'}, =>
            @div '5 Open', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'openTerminal'}, =>
                @div '1'
                @div 'Terminal - Open terminal in current folder', {class: 'description'}
              @div {class: 'item', click: 'openFileManager'}, =>
                @div '2'
                @div 'File manager - Show highlighted item in system file manager', {class: 'description', outlet: 'fileManagerItem'}
              @div {class: 'item', click: 'openSystem'}, =>
                @div '3'
                @div 'System - Open highlighted item with system default', {class: 'description'}
          @div {class: 'column'}, =>
            @div '6 View', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'viewRefresh'}, =>
                @div '1'
                @div 'Refresh - Refresh content of focused pane', {class: 'description'}
              @div {class: 'item', click: 'viewMirror'}, =>
                @div '2'
                @div 'Mirror - Show same content in other pane', {class: 'description'}
              @div {class: 'item', click: 'viewSwap'}, =>
                @div '3'
                @div 'Swap - Swap content of two panes', {class: 'description'}
          @div {class: 'column'}, =>
            @div '7 Compare', {class: 'title'}
            @div {class: 'body'}, =>
              @div {class: 'item', click: 'compareFolders'}, =>
                @div '1'
                @div 'Folders - Highlight difference between the two panes', {class: 'description'}
              @div {class: 'item', click: 'compareFiles'}, =>
                @div '2'
                @div 'Files - Show difference between content of highlighted files', {class: 'description'}

  dispose: ->
    @configDisposable.dispose();

  selectAll: -> @mainView.main.actions.selectAll()
  selectNone: -> @mainView.main.actions.selectNone()
  selectAdd: -> @mainView.main.actions.selectAdd()
  selectRemove: -> @mainView.main.actions.selectRemove()
  selectInvert: -> @mainView.main.actions.selectInvert()
  selectFolders: -> @mainView.main.actions.selectFolders()
  selectFiles: -> @mainView.main.actions.selectFiles()

  goProject: -> @mainView.main.actions.goProject();
  goEditor: -> @mainView.main.actions.goEditor();
  goDrive: -> @mainView.main.actions.goDrive();
  goRoot: -> @mainView.main.actions.goRoot();
  goHome: -> @mainView.main.actions.goHome();

  bookmarksAdd: -> @mainView.main.actions.bookmarksAdd();
  bookmarksRemove: -> @mainView.main.actions.bookmarksRemove();
  bookmarksOpen: -> @mainView.main.actions.bookmarksOpen();

  serversAdd: -> @mainView.main.actions.serversAdd();
  serversRemove: -> @mainView.main.actions.serversRemove();
  serversOpen: -> @mainView.main.actions.serversOpen();
  serversClose: -> @mainView.main.actions.serversClose();
  serversEdit: -> @mainView.main.actions.serversEdit();
  serversCache: -> @mainView.main.actions.serversCache();

  openTerminal: -> @mainView.main.actions.openTerminal();
  openFileManager: -> @mainView.main.actions.openFileSystem();
  openSystem: -> @mainView.main.actions.openSystem();

  viewRefresh: -> @mainView.main.actions.viewRefresh();
  viewMirror: -> @mainView.main.actions.viewMirror();
  viewSwap: -> @mainView.main.actions.viewSwap();

  compareFolders: -> @mainView.main.actions.compareFolders();
  compareFiles: -> @mainView.main.actions.compareFiles();

  setMainView: (@mainView) ->
    @rootMenuItem = @createRootMenuItem();
    @showMenuItem(@rootMenuItem);

    buttonClicked = @buttonClicked;

    @content.on 'click', 'button', ->
      buttonClicked($(this).text());

    if process.platform == "darwin"
      @fileManagerItem.text('Finder - Show highlighted item in Finder');
    else if process.platform == "win32"
      @fileManagerItem.text('Explorer - Show highlighted item in Explorer');

    @configDisposable = atom.config.observe 'atom-commander.menu.showMenuDetails', (value) =>
      if value
        @details.show();
      else
        @details.hide();

  settingsPressed: =>
    @mainView.hideMenuBar();
    atom.workspace.open('atom://config/packages/atom-commander');

  buttonClicked: (title) =>
    if (title == "")
      @showParentMenuItem();
    else
      @handleMenuItem(@currentMenuItem.getMenuItemWithTitle(title));

  showParentMenuItem: ->
    if @currentMenuItem.parent == null
      @mainView.hideMenuBar();
    else
      @handleMenuItem(@currentMenuItem.parent);

  reset: ->
    @showMenuItem(@rootMenuItem);

  createRootMenuItem: ->
    actions = @mainView.main.actions;
    root = new MenuItem(null, "0", "root");

    select = root.addMenuItem("1", "Select");
    select.addMenuItem("1", "All", actions.selectAll);
    select.addMenuItem("2", "None", actions.selectNone);
    select.addMenuItem("3", "Add", actions.selectAdd);
    select.addMenuItem("4", "Remove", actions.selectRemove);
    select.addMenuItem("5", "Invert", actions.selectInvert);
    select.addMenuItem("6", "Folders", actions.selectFolders);
    select.addMenuItem("7", "Files", actions.selectFiles);

    go = root.addMenuItem("2", "Go");
    go.addMenuItem("1", "Project", actions.goProject);
    go.addMenuItem("2", "Editor", actions.goEditor);
    go.addMenuItem("3", "Drive", actions.goDrive);
    go.addMenuItem("4", "Root", actions.goRoot);
    go.addMenuItem("5", "Home", actions.goHome);

    bookmarks = root.addMenuItem("3", "Bookmarks");
    bookmarks.addMenuItem("1", "Add", actions.bookmarksAdd);
    bookmarks.addMenuItem("2", "Remove", actions.bookmarksRemove);
    bookmarks.addMenuItem("3", "Open", actions.bookmarksOpen);

    server = root.addMenuItem("4", "Servers");
    server.addMenuItem("1", "Add", actions.serversAdd);
    server.addMenuItem("2", "Remove", actions.serversRemove);
    server.addMenuItem("3", "Open", actions.serversOpen);
    server.addMenuItem("4", "Close", actions.serversClose);
    server.addMenuItem("5", "Edit", actions.serversEdit);
    server.addMenuItem("6", "Cache", actions.serversCache);

    open = root.addMenuItem("5", "Open");
    open.addMenuItem("1", "Terminal", actions.openTerminal);

    if process.platform == "darwin"
      open.addMenuItem("2", "Finder", actions.openFileSystem);
    else if process.platform == "win32"
      open.addMenuItem("2", "Explorer", actions.openFileSystem);
    else
      open.addMenuItem("2", "File Manager", actions.openFileSystem);

    open.addMenuItem("3", "System", actions.openSystem);

    view = root.addMenuItem("6", "View");
    view.addMenuItem("1", "Refresh", actions.viewRefresh);
    view.addMenuItem("2", "Mirror", actions.viewMirror);
    view.addMenuItem("3", "Swap", actions.viewSwap);

    compare = root.addMenuItem("7", "Compare");
    compare.addMenuItem("1", "Folders", actions.compareFolders);
    compare.addMenuItem("2", "Files", actions.compareFiles);

    return root;

  showMenuItem: (@currentMenuItem) ->
    @content.empty();

    @content.append $$ ->
      @button {class: 'btn icon-arrow-up inline-block'}

    for id in @currentMenuItem.ids
      subMenuItem = @currentMenuItem.getMenuItem(id);

      @content.append $$ ->
        @button subMenuItem.title, {class: 'btn btn-primary inline-block'}

  handleKeyDown: (event) ->
    charCode = event.which | event.keyCode;

    if event.shiftKey or (charCode == 27)
      @showParentMenuItem();

  handleKeyUp: (event) ->
    charCode = event.which | event.keyCode;

    # Not sure if this the right way, but on OSX it allows the keypad to be used.
    if charCode >= 96
      charCode -= 48;

    sCode = String.fromCharCode(charCode);

    if sCode == "0"
      @showParentMenuItem();
    else
      subMenuItem = @currentMenuItem.getMenuItem(sCode);
      @handleMenuItem(subMenuItem);

  handleMenuItem: (menuItem) ->
    if menuItem
      if menuItem.callback
        menuItem.callback();
      else
        @showMenuItem(menuItem);
