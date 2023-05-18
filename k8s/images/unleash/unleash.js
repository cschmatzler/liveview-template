const unleash = require("unleash-server");
const fs = require("node:fs");

unleash
  .start({
    logLevel: "debug",
    db: {
      ssl: {
        ca: fs
          .readFileSync("/certs/ca.liveview-template.app-bundle.pem")
          .toString(),
      },
    },
    server: {
      host: "0.0.0.0",
    },
    authentication: {
      createAdminUser: false,
    },
  })
  .then((unleash) => {
    console.log(
      `Unleash started on http://localhost:${unleash.app.get("port")}`
    );
  });
