require("dotenv").config({
    path: `.env.${process.env.NODE_ENV}`,
  })
  
  module.exports = {
    siteMetadata: {
      title: `cState`,
    },
    plugins: [
      // other plugins
      {
        resolve: "gatsby-plugin-netlify-cms",
        options: {
          modulePath: `${__dirname}/src/cms/cms.js`,
          enableIdentityWidget: true,
          publicPath: "admin",
          htmlTitle: "Content Manager",
          manualInit: true,
        },
      },
    ],
  }
  