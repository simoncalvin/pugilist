var express = require('express');
var cors = require('cors');
var proxy = require('http-proxy-middleware');

var app = express();

var config = {
    target: 'https://api.shortboxed.com', 
    changeOrigin: false,
    pathRewrite: { '^/api' : '' },
    secure: false,
    onError: function onError(err, req, res) {
        res.writeHead(500, {'Content-Type': 'text/plain'});
        res.end('Something went wrong.');
    },
    onProxyRes: function (proxyRes, req, res) {
        proxyRes.headers['x-added'] = 'foobar';
        delete proxyRes.headers['x-removed'];
    },
    onProxyReq: function (proxyReq, req, res) {
        // add custom header to request
        proxyReq.setHeader('x-powered-by', 'foobar');
    }
};

app.use(cors({ origin: "http://localhost:3000"}));
app.use('/api', proxy(config));
app.listen(3001);

