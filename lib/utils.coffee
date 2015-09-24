PathUtil = require 'path'
SimpleEncryptor = require 'simple-encryptor'
PasswordDialog = require './dialogs/password-dialog'
FileController = require './controllers/file-controller'
DiffView = require './views/diff/diff-view'

module.exports =
class Actions

  # Opens a DiffView with the given title. left and right can either
  # be a file or a string.
  @compareFiles: (title, left, right) ->
    view = new DiffView(title, left, right);
    pane = atom.workspace.getActivePane();
    item = pane.addItem(view, 0);
    pane.activateItem(item);

  @getFirstFileViewItem: (viewItems) ->
    if viewItems == null
      return null;

    for viewItem in viewItems
      if viewItem.itemController instanceof FileController
        return viewItem;

    return null;

  @sortItems: (items) ->
    items.sort (item1, item2) ->
      name1 = item1.getBaseName();
      name2 = item2.getBaseName();

      if name1 < name2
        return -1;
      else if name1 > name2
        return 1;

      return 0;

  @getServersPath: ->
    return PathUtil.join(fsp.getHomeDirectory(), ".atom-commander", "servers");

  @promptForPassword: (prompt, callback) ->
    dialog = new PasswordDialog(prompt, callback);
    dialog.attach();

  @encrypt: (text, key) ->
    return SimpleEncryptor(@padKey(key)).encrypt(text);

  @decrypt: (text, key) ->
    return SimpleEncryptor(@padKey(key)).decrypt(text);

  @padKey: (key) ->
    while key.length < 16
      key += key;

    return key;
