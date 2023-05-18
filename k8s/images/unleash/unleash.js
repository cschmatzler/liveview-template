const unleash = require("unleash-server");

unleash
  .start({
    createAdminUser: false,
  })
  .then((unleash) => {
    console.log(
      `Unleash started on http://localhost:${unleash.app.get("port")}`
    );
  });
