const path = require('path');
const clean = require('clean-webpack-plugin');
const favicons = require('favicons-webpack-plugin');
const html = require('html-webpack-plugin');

module.exports = {
  entry: {
    index: './src/index.js',
  }, 
  output: {
    filename: '[name].js',
    path: path.resolve(__dirname, 'dist')
  },
  resolve: {
    extensions: ['.js', '.elm']
  }, 
  devServer: {
    contentBase: './dist',
    port:5000
  },
  devtool: "cheap-module-eval-source-map",
  module: {
    rules: [
      {
            test: /\.css$/,
            use: [ 'style-loader', 'css-loader' ]
      },
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [{
          loader: 'elm-webpack-loader',
          options: {
            verbose: true,
            warn: true,
            debug: true
          }
        }]
      }
    ]
  },
  plugins: [
    new clean([ path.resolve(__dirname, 'dist') ]),
    new favicons(path.resolve(__dirname, 'favicon.png')),
    new html({ title: 'puglist: your pull list'})
  ]
};
