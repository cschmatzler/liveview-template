const unleash = require("unleash-server");
const fs = require("node:fs");

unleash
  .start({
    createAdminUser: false,
    db: {
      ssl: {
        ca: fs.readFileSync("/certs/").toString(),
      },
    },
  })
  .then((unleash) => {
    console.log(
      `Unleash started on http://localhost:${unleash.app.get("port")}`
    );
  });
