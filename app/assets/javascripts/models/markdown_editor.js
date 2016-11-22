//= require codemirror
//= require codemirror/addons/mode/overlay
//= require codemirror/addons/display/placeholder
//= require codemirror/modes/markdown
//= require codemirror/modes/gfm
//= require ot-text
//= require sharedb-client
//= require sharedb-codemirror

class MarkdownEditor {
  constructor(opts) {
    ShareDB.types.map['json0'].registerSubtype(OTText.type);

    this.doc = this.connect().get('documents', opts.doc);
    this.editor = CodeMirror.fromTextArea(opts.el, {
      mode: "gfm",
      viewportMargin: Infinity,
      lineWrapping: true
    });

    this.broadcast();
  }

  // process.env.SHAREDB_URL
  connect() {
    const socket = new WebSocket("ws://localhost:5000/");
    const connection = new ShareDB.Connection(socket);
    return connection;
  }

  // process.env.SHAREDB_OUTPUT
  broadcast() {
    ShareDBCodeMirror.attachDocToCodeMirror(this.doc, this.editor, {
      key: 'content',
      verbose: true
    });
  }
}
