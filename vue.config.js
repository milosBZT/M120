module.exports = {
    configureWebpack: {
      devServer: {
        proxy: 'http://localhost:8080/',
        // headers: { "Access-Control-Allow-Origin": "*" },
      }
    }
  };