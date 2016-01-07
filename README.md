
React Lite Uploader
----

> This project is no mature, do not use it in production!

Uploader component from Talk by Teambition.

Demo http://ui.talk.ai/react-lite-uploader

Based on the work of https://github.com/mailru/FileAPI

### Supposition

Contains internal business logic defined at Talk by Teambition.

### Usage

```bash
npm i --save react-lite-uploader
```

```coffee
UploadButton = require('react-lite-uploader').Button
UploadArea = require('react-lite-uploader').Area
uploadUtil = require('react-lite-uploader').util
```

#### `UploadButton`, `UploadArea`: React Components

props:

* `url`, string, server url to upload files, required
* `headers`, object of headers, optional
* `accept`, string of accepted types, seperated by commas like `jpg,png`, optional, defaults to `''`
* `multiple`, bool, optional, defaults to `false`
* `onFileHover`, function to response to dragging files, optional(only used handling dropping files)
* `onCreate`, function, optional
* `onProgress`, function, optional
* `onSuccess`, function, required
* `onError`, function, required

Notice: `UploadArea` is not suggested due to the lack of flexibility, use `uploadUtil` instead.

##### `uploadUtil`: utilities to handle dropping and pasting

* `uploadUtil.handleFileDropping` `(event, props) ->`
* `uploadUtil.handlePasteEvent` `(targetElement, props) ->`

Remember to include `react-lite-uploader/src/styles.css` in you project.

Read [`page.coffee`][example] for details.

[example]: https://github.com/teambition/react-lite-uploader/blob/master/src/app/page.coffee

### Develop

Based on Jianliao's project template:

https://github.com/teambition/coffee-webpack-starter

### License

MIT
