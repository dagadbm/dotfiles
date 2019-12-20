'use strict';

exports.decorateBrowserOptions = options => Object.assign({}, options, {
  fullscreen: true,
  titleBarStyle: 'hidden',
});
