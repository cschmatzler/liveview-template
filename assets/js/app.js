import "phoenix_html";
import { Socket } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import Alpine from "alpinejs";
import focus from "@alpinejs/focus";
import ui from "@alpinejs/ui";
import topbar from "../vendor/topbar";

import hooks from "./hooks";

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");

Alpine.plugin(focus);
Alpine.plugin(ui);
window.Alpine = Alpine;
let liveSocket = new LiveSocket("/live", Socket, {
  dom: {
    onBeforeElUpdated(from, to) {
      if (from._x_dataStack) {
        window.Alpine.clone(from, to);
      }
    },
  },
  params: { _csrf_token: csrfToken },
  hooks: hooks,
});

topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (info) =>
  topbar.delayedShow(200)
);
window.addEventListener("phx:page-loading-stop", (info) => topbar.hide());

liveSocket.connect();

window.liveSocket = liveSocket;

Alpine.start();
