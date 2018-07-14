fs = require 'fs'
fsp = require 'fs-plus'
SSH2 = require 'ssh2'
PathUtil = require('path')
Utils = require '../utils'
SFTPFileSystem = require '../fs/ftp/sftp-filesystem'
{View, TextEditorView} = require 'atom-space-pen-views'

module.exports =
class SFTPDialog extends View

  constructor: ->
    super();
    @ssh2 = null;

  setParentDialog: (@parentDialog) ->

  @content: ->
    @div class: "atom-commander-ftp-dialog", =>
      # @div "New SFTP Connection", {class: "heading"}
      @table =>
        @tbody =>
          @tr =>
            @td "Name", {class: "text-highlight", style: "width:40%"}
            @td =>
              @subview "nameEditor", new TextEditorView(mini: true)
          @tr =>
            @td "URL", {class: "text-highlight", style: "width:40%"}
            @td "sftp://", {outlet: "url", style: "padding-bottom: 0.5em"}
          @tr =>
            @td "Host", {class: "text-highlight", style: "width:40%"}
            @td =>
              @subview "serverEditor", new TextEditorView(mini: true)
          @tr =>
            @td "Port", {class: "text-highlight", style: "width:40%"}
            @td =>
              @subview "portEditor", new TextEditorView(mini: true)
          @tr =>
            @td "Folder", {class: "text-highlight", style: "width:40%"}
            @td =>
              @subview "folderEditor", new TextEditorView(mini: true)
          @tr =>
            @td "Username", {class: "text-highlight", style: "width:40%"}
            @td =>
              @subview "usernameEditor", new TextEditorView(mini: true)
          @tr =>
            @td "Password", {class: "text-highlight", style: "width:40%"}
            @td =>
              @div {class: "password"}, =>
                @subview "passwordEditor", new TextEditorView(mini: true)
              @div "Leave empty to prompt for password", {class:"encrypted"}
          @tr =>
            @td =>
              @input {type: "radio", outlet: "loginWithPasswordCheckBox"}
              @span "Login with password", {class: "text-highlight", style: "margin-left:5px"}
          # @tr =>
          #   @td "Password", {class: "text-highlight indent", style: "width:40%"}
            # @td {class: "password"}, =>
              # @subview "passwordEditor", new TextEditorView(mini: true)
          @tr =>
            @td =>
              @input {type: "radio", outlet: "loginWithPrivateKeyCheckBox"}
              @span "Login with private key", {class: "text-highlight", style: "margin-left:5px"}
          @tr =>
            @td "Path to file", {class: "text-highlight indent", style: "width:40%"}
            @td =>
              @subview "privateKeyPathEditor", new TextEditorView(mini: true)
          @tr =>
            @td {class: "indent", style: "width:40%"}, =>
              @input {type: "checkbox", outlet: "usePassphraseCheckBox"}
              @span "Use passphrase", {class: "text-highlight", style: "margin-left:5px"}
            @td =>
              @div {class: "password"}, =>
                @subview "passphraseEditor", new TextEditorView(mini: true)
          @tr =>
            @td =>
              @input {type: "checkbox", outlet: "storeCheckBox"}
              @span "Store password\\phrase", {class: "text-highlight", style: "width:40%; margin-left:5px"}
            @td =>
              @span "These are encrypted", {class: "encrypted"}
      @div {class: "test-button-panel"}, =>
        @button "Test", {class: "btn", click: "test", outlet: "testButton"}
      @div {class: "bottom-button-panel"}, =>
        @button "Cancel", {class: "btn", click: "cancel", outlet: "cancelButton"}
        @button "OK", {class: "btn", click: "confirm", outlet: "okButton"}
      @div =>
        @span {class: "loading loading-spinner-tiny inline-block", outlet: "spinner"}
        @span {class: "message", outlet: "message"}

  initialize: ->
    @nameEditor.attr("tabindex", 1);
    @serverEditor.attr("tabindex", 2);
    @portEditor.attr("tabindex", 3);
    @folderEditor.attr("tabindex", 4);
    @usernameEditor.attr("tabindex", 5);
    @passwordEditor.attr("tabindex", 6);
    @privateKeyPathEditor.attr("tabindex", 7);
    @usePassphraseCheckBox.attr("tabindex", 8);
    @passphraseEditor.attr("tabindex", 9);
    @storeCheckBox.attr("tabindex", 10);
    @testButton.attr("tabindex", 11);
    @okButton.attr("tabindex", 12);
    @cancelButton.attr("tabindex", 13);

    @passwordEditor.addClass("password-editor");
    @passphraseEditor.addClass("password-editor");

    @spinner.hide();
    @portEditor.getModel().setText("22");
    @privateKeyPathEditor.getModel().setText(PathUtil.join("~", ".ssh", "id_rsa"));
    @loginWithPasswordCheckBox.prop("checked", true);
    @storeCheckBox.prop("checked", true);

    @loginWithPasswordCheckBox.change =>
      @loginWithPrivateKeyCheckBox.prop("checked", !@isLoginWithPasswordSelected());
      @refreshError();

    @loginWithPrivateKeyCheckBox.change =>
      @loginWithPasswordCheckBox.prop("checked", !@isLoginWithPrivateKeySelected());
      @refreshError();

    @usePassphraseCheckBox.change =>
      @refreshError();

    @serverEditor.getModel().onDidChange =>
      @refreshURL();
      @refreshError();

    @portEditor.getModel().onDidChange =>
      @refreshURL();
      @refreshError();

    @folderEditor.getModel().onDidChange =>
      @refreshURL();
      @refreshError();

    @usernameEditor.getModel().onDidChange =>
      @refreshError();

    @passwordEditor.getModel().onDidChange =>
      @refreshError();

    @privateKeyPathEditor.getModel().onDidChange =>
      @refreshError();

    atom.commands.add @element,
      "core:confirm": => @confirm()
      "core:cancel": => @cancel()

    @refreshError();

  # Populates the fields with an existing server's config. This is used
  # when editing a server.
  populateFields: (config) ->
    password = config.password;
    passphrase = config.passphrase;

    if !password?
      password = '';

    if !passphrase?
      passphrase = '';

    @nameEditor.getModel().setText(config.name);
    @serverEditor.getModel().setText(config.host);
    @portEditor.getModel().setText(config.port + "");
    @folderEditor.getModel().setText(config.folder);
    @usernameEditor.getModel().setText(config.username);
    @passwordEditor.getModel().setText(password);
    @privateKeyPathEditor.getModel().setText(config.privateKeyPath);
    @passphraseEditor.getModel().setText(passphrase);
    @storeCheckBox.prop("checked", config.storePassword);
    @usePassphraseCheckBox.prop("checked", config.usePassphrase);
    @loginWithPasswordCheckBox.prop("checked", config.loginWithPassword);
    @loginWithPrivateKeyCheckBox.prop("checked", !config.loginWithPassword);

    @refreshURL();
    @refreshError();

  getPort: ->
    port = @portEditor.getModel().getText().trim();

    if port.length == 0
      return 22;

    port = parseInt(port);

    if isNaN(port)
      return null;

    return port;

  refreshURL: ->
    server = @getServer();
    port = @portEditor.getModel().getText().trim();

    url = "sftp://" + server;

    if (server.length > 0)
      port = @getPort();

      if (port != null) and (port != 22)
        url += ":" + port;

    url += @getFolder();
    @url.text(url);

  refreshError: ->
    message = @getErrorMessage();

    if (message == null)
      @showMessage("", 0);
    else
      @showMessage(message, 2);

  getErrorMessage: ->
    server = @getServer();
    if server.length == 0
      return "Host must be specified."

    username = @getUsername();
    if username.length == 0
      return "Username must be specified."

    port = @getPort();
    if port == null
      return "Invalid port number.";

    if @serverExists(server, port, username)
      return "This server has already been added.";

    # if @isLoginWithPasswordSelected() and @getPassword().length == 0
    #   return "Password not specified."

    if @isLoginWithPrivateKeySelected()
      if @getPrivateKeyPath(false).length == 0
        return "Path to private key not specified.";
      else if !@isPrivateKeyPathValid()
        return "Private key file not found.";

      # if @isUsePassphraseSelected() and @getPassphrase().length == 0
      #   return "Passphrase not specified.";

    return null;

  showMessage: (text, type) ->
    @messageType = type;

    @message.removeClass("text-error");
    @message.removeClass("text-warning");
    @message.removeClass("text-success");

    if @messageType == 0
      @message.addClass("text-success");
    else if @messageType == 1
      @message.addClass("text-warning");
    else
      @message.addClass("text-error");

    @message.text(text);

  serverExists: (server, port, username) ->
    id = "sftp_"+server+"_"+port+"_"+username;
    return @parentDialog.serverExists(id);

  getName: ->
    return @nameEditor.getModel().getText().trim();

  getServer: ->
    return @serverEditor.getModel().getText().trim();

  getFolder: ->
    folder = @folderEditor.getModel().getText().trim();

    if (folder.length > 0)
      if folder[0] != "/"
        folder = "/"+folder;
    else
      folder = "/";

    return folder;

  getUsername: ->
    return @usernameEditor.getModel().getText().trim();

  getPassword: ->
    return @passwordEditor.getModel().getText().trim();

  getPrivateKeyPath: (resolve) ->
    path = @privateKeyPathEditor.getModel().getText().trim();

    if resolve
      path = Utils.resolveHome(path);

    return path;

  getPassphrase: ->
    return @passphraseEditor.getModel().getText().trim();

  isLoginWithPasswordSelected: ->
    return @loginWithPasswordCheckBox.is(":checked");

  isLoginWithPrivateKeySelected: ->
    return @loginWithPrivateKeyCheckBox.is(":checked");

  isUsePassphraseSelected: ->
    return @usePassphraseCheckBox.is(":checked");

  isPrivateKeyPathValid: ->
    path = @getPrivateKeyPath(true);

    if path.length == 0
      return false;

    return fsp.isFileSync(path);

  getPrivateKey: ->
    if !@isPrivateKeyPathValid()
      return '';

    return fs.readFileSync(@getPrivateKeyPath(true), 'utf8');

  isStoreCheckBoxSelected: ->
    return @storeCheckBox.is(":checked");

  getSFTPConfig: (testing) ->
    config = {};

    config.protocol = "sftp";
    config.name = @getName();
    config.host = @getServer();
    config.port = @getPort();
    config.folder = @getFolder();
    config.username = @getUsername();
    config.password = @getPassword();
    config.passwordDecrypted = true;
    config.storePassword = @isStoreCheckBoxSelected();
    config.privateKeyPath = @getPrivateKeyPath(false);
    config.passphrase = @getPassphrase();
    config.loginWithPassword = @isLoginWithPasswordSelected();
    config.usePassphrase = @isUsePassphraseSelected();

    if testing
      config.privateKey = @getPrivateKey();

    return config;

  selected: ->
    @nameEditor.focus();
  # attach: ->
  #   @panel = atom.workspace.addModalPanel(item: this.element);
  #   @serverEditor.focus();
  #   @serverEditor.getModel().scrollToCursorPosition();

  close: ->
    @parentDialog.close();
    # panelToDestroy = @panel;
    # @panel = null;
    # panelToDestroy?.destroy();
    # @containerView.requestFocus();

  confirm: ->
    if @hasError()
      return;

    @parentDialog.addServer(@getSFTPConfig(false));

  cancel: ->
    @parentDialog.close();

  hasError: ->
    return @messageType == 2;

  test: ->
    if @hasError() or (@ssh2 != null)
      return;

    config = @getSFTPConfig(false);
    fs = new SFTPFileSystem(@parentDialog.getMain(), null, config);

    fs.onError (err) =>
      @parentDialog.attach();

      if err.canceled
        @showMessage("", 0);
      else
        @showMessage("Connection failed. "+err.message, 1);

      fs.disconnect();

    fs.onConnected () =>
      @parentDialog.attach();
      @showMessage("Connection successful", 0);
      fs.disconnect();

    fs.onDisconnected () =>
      @parentDialog.attach();

    fs.connect();
