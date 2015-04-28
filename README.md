
React Lite Dropdown
----

> This project is experimental, do not use it in production!

Uploader component from Talk by Teambition.

Demo http://teambition.github.io/react-lite-uploader/

### Properties

Not ready for real project.

### Supposition

Contains internal bussiness code defined at Teambition.

### Usage

```bash
npm i --save react-lite-uploader
```

### Develop

```text
npm i
```

You need a static file server for the HTML files. Personally I suggest using Nginx.

Develop:

```bash
gulp html # regenerate index.html
webpack-dev-server --hot # enable live-reloading
```

Build (Pack and optimize js, reivision js and add entry in `index.html`):

```bash
gulp build
```

### License

MIT
