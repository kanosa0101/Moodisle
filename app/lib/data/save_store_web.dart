import 'dart:js_interop';

@JS('window.localStorage.getItem')
external JSString? _getItem(JSString key);

@JS('window.localStorage.setItem')
external void _setItem(JSString key, JSString value);

String? readSave(String key) => _getItem(key.toJS)?.toDart;

void writeSave(String key, String value) => _setItem(key.toJS, value.toJS);
