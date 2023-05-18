const unleash = require("unleash-server");
const fs = require("node:fs");

unleash
  .start({
    createAdminUser: false,
    db: {
      ssl: {
        ca: fs.readFileSync("/certs/ca.liveview-template.app-bundle.pem").toString(),
      },
    },
  })
  .then((unleash) => {
    console.log(
      `Unleash started on http://localhost:${unleash.app.get("port")}`
    );
  });
